//
//  MapViewController.swift
//  Feed Me
//
//  Created by Si Li on 8/30/14.
//  Copyright (c) 2014 Camptivity INC. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, NewEventViewControllerDelegate, FloatRatingViewDelegate {
    
    
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var stopNavigationButton: UIButton!
    @IBOutlet weak var currentRatingScore: UILabel!
    @IBOutlet weak var yourRatingScore: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var rateSubmitButton: UIButton!
    //@property (nonatomic, strong) MBProgressHUD *hud;
    
    var hub = MBProgressHUD()
    var markerCoordinate = CLLocationCoordinate2DMake(0, 0)
    var markerTitle = ""
    //var searchedTypes = ["atm", "bar", "building", "gym", "housing","landmark", "library", "parking", "restaurant", "restroom", "store", "water"]
    var searchedTypes = ["restroom"]
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
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    @IBAction func categoryButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("Types Segue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //var image: UIImage = UIImage(named: "purplesky")!
        //self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        mapView.camera = GMSCameraPosition.cameraWithLatitude(32.87993263160078, longitude: -117.2309485336882, zoom: 14)
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: 45, right: 0)
        mapView.delegate = self
        stopNavigationButton.hidden = true
        rateView.hidden = true
        
        /********************************************************************/
        rateSubmitButton.hidden = true
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 5
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        
        // Labels init
        self.yourRatingScore.text = NSString(format: "%.2f", self.floatRatingView.rating)
        //self.currentRatingScore.text = NSString(format: "%.2f", self.floatRatingView.rating)
        /*********************************************************************/
        
       // var score:int = (dataProvider.lookupLocationByCoord(32.87993263160078, lon: -117.2309485336882)["avgRank"])
        //println(score)
        fetchNearbyLocationsAndEvents()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("Debug: Map View is Appearing")
        
        super.viewWillAppear(false)
        
        //Check to see if we should perform an event pinning action
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if(appDelegate.doPin == true)
        {
            appDelegate.doPin = false
            let coordinate = CLLocationCoordinate2D(latitude: appDelegate.lat, longitude: appDelegate.long)
            //TODO: Map Does funky stuff when pin event command is invoked
            //didCreateEventAtCoordinate(appDelegate.name, Description: appDelegate.event_description, coordinate: coordinate)
            var event : PFObject = ParseEvents.getEventByName(appDelegate.name)
            println(event["name"] as NSString)
            
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake((event["location"] as PFGeoPoint).latitude, (event["location"] as PFGeoPoint).longitude)
            marker.title = (event["name"] as NSString)
            marker.snippet = event["description"] as NSString?
            marker.userData = "newEvent"
            
            let userImageFile = event["icon"] as PFFile
            let image = UIImage(data:userImageFile.getData())
            marker.icon = imageResize(image!, sizeChange: CGSizeMake(15, 15))

            marker.map = self.mapView
            
            self.mapView.selectedMarker = marker
        }
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
    
    func fetchNearbyEvents() {
        var eventList = ParseEvents.getEvents()
        
        for event in eventList{
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake((event["location"] as PFGeoPoint).latitude, (event["location"] as PFGeoPoint).longitude)
            marker.title = (event["name"] as NSString)
            marker.snippet = event["description"] as NSString?
            marker.userData = "newEvent"
            
            let userImageFile = event["icon"] as PFFile
            let image = UIImage(data:userImageFile.getData())
            marker.icon = imageResize(image!, sizeChange: CGSizeMake(15, 15))
            marker.map = self.mapView
            //println("Hello world" + marker.description)
        }
    }
    
    func fetchNearbyLocationsAndEvents() {
//        self.hub.show(true)
//        self.hub.mode = MBProgressHUDModeIndeterminate
//        self.hub.labelText = "Loading"
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = "Loading"
        
        
        //NSLog("here is the fetchnearbylocations")
        mapView.clear()
        
        var results = ParseLocations.getLocationsNearMe(searchedTypes)
            
        
            for result in results {
                var marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake((result["location"] as PFGeoPoint).latitude, (result["location"] as PFGeoPoint).longitude)
                marker.title = (result["name"] as NSString)
                marker.snippet = result["description"] as NSString?
                marker.userData = result["category"] as NSString
                var event = imageResize(UIImage(named: result["category"] as NSString)!, sizeChange: CGSizeMake(15, 15))
                marker.icon = event
                marker.map = self.mapView
            }
        
        fetchNearbyEvents()
        //self.hub.show(false)
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
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
        //marker.icon = UIImage(named: "newEvent")
        marker.userData = "newEvent"
        marker.map = self.mapView
        
        //pop out the info window
        self.mapView.selectedMarker = marker
        self.mapView.animateToLocation(CLLocationCoordinate2DMake(coordinate.latitude + 0.005, coordinate.longitude))
    }
    
    
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        var coor = [ "longitude" : coordinate.longitude, "latitude" : coordinate.latitude ]
        performSegueWithIdentifier("goToCreateNewEvent", sender: coor)
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        
        return false
    }
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        if marker.userData as NSString != "newEvent" {
            rateView.hidden = false
            markerCoordinate = marker.position
            markerTitle = marker.title as NSString
            
            
            let x : Float = (ParseLocations.getLocationByName(marker.title).objectForKey("avgRank"))! as Float
            var myString = String(format:"%.1f", x)
            self.currentRatingScore.text = myString
            self.floatRatingView.rating = x
        }
        
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
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        rateView.hidden = true
    }
    
//    @IBAction func refreshPlaces(sender: AnyObject) {
//        fetchNearbyLocations()
//    }
    
    @IBAction func stopButtonClicked(sender: AnyObject) {
        stopNavigationButton.hidden = true
        rateView.hidden = true
        removePolyline()
    }
    
    
    // MARK: - Types Controller Delegate
    func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
        searchedTypes = sorted(controller.selectedTypes)
        dismissViewControllerAnimated(true, completion: nil)
        fetchNearbyLocationsAndEvents()
        
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        self.yourRatingScore.text = NSString(format: "%.2f", self.floatRatingView.rating)
        rateSubmitButton.hidden = false
        
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.currentRatingScore.text = NSString(format: "%.2f", self.floatRatingView.rating)
    }
    
    @IBAction func ratingTypeChanged(sender: UISegmentedControl) {
        self.floatRatingView.halfRatings = sender.selectedSegmentIndex==1
    }
    
    @IBAction func rateButtonClicked(sender: UIButton) {
        //println(ParseLocations.getLocationByName(markerTitle).objectId)
        
        var objectId = ParseLocations.getLocationByName(markerTitle).objectId
        var rating : Int = NSString(format: "%.2f", self.floatRatingView.rating).integerValue
        
        ParseLocations.postLocationRanks("Genius", rating:rating, review:"This is a fantastic place", objId:objectId)
        
        let x : Float = (ParseLocations.getLocationByName(markerTitle).objectForKey("avgRank"))! as Float
        var myString = String(format:"%.1f", x)
        self.currentRatingScore.text = myString
        self.floatRatingView.rating = x
        
        let alert = UIAlertView()
        alert.title = "Success"
        alert.message = "Your rating have been saved!"
        alert.addButtonWithTitle("Got it")
        alert.delegate = self
        alert.show()
    }
    
}