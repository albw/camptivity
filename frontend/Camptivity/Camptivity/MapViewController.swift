//
//  MapViewController.swift
//  Feed Me
//
//  Created by Si Li on 8/30/14.
//  Copyright (c) 2014 Camptivity INC. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
  
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var mapView: GMSMapView!
    
  var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant", "restroom"]
  let dataProvider = ParseDataProvider()
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.camera = GMSCameraPosition.cameraWithLatitude(32.87993263160078, longitude: -117.2309485336882, zoom: 14)
    mapView.myLocationEnabled = true
    mapView.settings.myLocationButton = true
    mapView.delegate = self
    
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
  }
    
    func fetchNearbyLocations() {
        mapView.clear()
        
        dataProvider.fetchLocationsBaseOnCategories(searchedTypes) { locations in
            for location in locations {
                NSLog("%@\n", (location["name"] as NSString))
                
                var marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake((location["location"] as PFGeoPoint).latitude, (location["location"] as PFGeoPoint).longitude)
                marker.title = (location["name"] as NSString)
                marker.snippet = location["description"] as NSString
                marker.icon = UIImage(named: "restroom")
                marker.map = self.mapView
            }
        }
    }
    
    @IBAction func refreshPlaces(sender: AnyObject) {
        fetchNearbyLocations()
    }

  
  // MARK: - Types Controller Delegate
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = sorted(controller.selectedTypes)
    dismissViewControllerAnimated(true, completion: nil)
    fetchNearbyLocations()
  }
}