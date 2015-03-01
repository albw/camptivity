//
//  MapViewController.swift
//  Feed Me
//
//  Created by Si Li on 8/30/14.
//  Copyright (c) 2014 Camptivity INC. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, NewEventViewControllerDelegate {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var stopNavigationButton: UIButton!
    
    var searchedTypes = ["bar", "grocery_or_supermarket", "restaurant", "restroom"]
    let dataProvider = ParseDataProvider()
    var polylineArray : NSMutableArray = []
    
    var randomLineColor: UIColor {
        get {
            let randomRed = CGFloat(drand48())
            let randomGreen = CGFloat(drand48())
            let randomBlue = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.camera = GMSCameraPosition.cameraWithLatitude(32.87993263160078, longitude: -117.2309485336882, zoom: 14)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        stopNavigationButton.hidden = true
        
        fetchNearbyLocations()
    }
    
    
    @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
        let segmentedControl = sender as UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeSatellite
        case 2:
            mapView.mapType = kGMSTypeHybrid
        default:
            mapView.mapType = mapView.mapType
        }
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Types Segue" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = segue.destinationViewController.topViewController as TypesTableViewController
            controller.selectedTypes = searchedTypes
            controller.delegate = self
        }
        
        if segue.identifier == "goToCreateNewEvent"
        {
            let coordinate = sender as [String:Double]
            let controller = segue.destinationViewController as NewEventViewController
            controller.delegate = self
            controller.location = CLLocationCoordinate2DMake(coordinate["latitude"]!, coordinate["longitude"]!)
        }
    }
    
    func fetchNearbyLocations() {
        //NSLog("here is the fetchnearbylocations")
        mapView.clear()
        
        dataProvider.fetchLocationsNearMe(searchedTypes) { results in
            for result in results {
                var marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake((result["location"] as PFGeoPoint).latitude, (result["location"] as PFGeoPoint).longitude)
                marker.title = (result["name"] as NSString)
                marker.snippet = result["description"] as NSString
                marker.userData = result["category"] as NSString
                marker.icon = UIImage(named: result["category"] as NSString)
                marker.map = self.mapView
            }
        }
    }
    
    //remove all the polyline on the map
    func removePolyline() {
        for polyline in self.polylineArray {
            (polyline as GMSPolyline).map = nil
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        removePolyline()
        
        dataProvider.fetchDirectionsFrom(mapView.myLocation.coordinate, to: marker.position) {optionalRoute in
            if let encodedRoute = optionalRoute {
                
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = self.mapView
                line.strokeColor = self.randomLineColor
                
                self.polylineArray.addObject(line)
                mapView.selectedMarker = nil
            }
        }
        stopNavigationButton.hidden = false
    }
    
    func didCreateEventAtCoordinate( name: NSString, Description: NSString, coordinate: CLLocationCoordinate2D ) {
        var marker = GMSMarker()
        
        marker.position = coordinate
        marker.title = name
        marker.snippet = Description
        marker.map = self.mapView
        
        //pop out the info window
        //self.mapView.selectedMarker = marker
        self.mapView.animateToLocation(coordinate)
    }
    
    
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        var coor = [ "longitude" : coordinate.longitude, "latitude" : coordinate.latitude ]
        performSegueWithIdentifier("goToCreateNewEvent", sender: coor)
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        
        return false
    }
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            infoView.nameLabel.text = marker.title
            infoView.placePhoto.image = UIImage(named: marker.userData as NSString)
            infoView.descriptionLabel.text = marker.snippet
            return infoView
        }
        else {
            return nil
        }
    }
    
    
    @IBAction func refreshPlaces(sender: AnyObject) {
        fetchNearbyLocations()
    }
    
    @IBAction func stopButtonClicked(sender: AnyObject) {
        stopNavigationButton.hidden = true
        removePolyline()
    }
    
    
    // MARK: - Types Controller Delegate
    func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
        searchedTypes = sorted(controller.selectedTypes)
        dismissViewControllerAnimated(true, completion: nil)
        fetchNearbyLocations()
    }
}