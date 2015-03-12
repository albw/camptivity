//
//  LocationTableViewController.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 3/11/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    //Location Data
    var locationData: [PFObject]!
    var restroomData: [PFObject]!
    var barData: [PFObject]!
    var buildingData: [PFObject]!
    var landmarkData: [PFObject]!
    var gymData: [PFObject]!
    var parkingData: [PFObject]!
    var storeData: [PFObject]!
    var housingData: [PFObject]!
    var atmData: [PFObject]!
    var restraurantData: [PFObject]!
    
    //Count of Locations
    var numLocations = 0
    var numRestrooms = 0
    var numBars = 0
    var numBuilding = 0
    var numLandmark = 0
    var numGym = 0
    var numParking = 0
    var numStore = 0
    var numHousing = 0
    var numAtm = 0
    var numRestraurant = 0
    
    //Different category searches
    var searchedTypes = ["restroom", "bar", "building", "landmark", "gym", "parking", "store", "housing", "atm", "restraurant"]
    var restroomType = ["restroom"]
    var barType = ["bar"]
    var buildingType = ["building"]
    var landmarkType = ["landmark"]
    var gymType = ["gym"]
    var parkingType = ["parking"]
    var storeType = ["store"]
    var housingType = ["housing"]
    var atmType = ["atm"]
    var restraurantType = ["restraurant"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 22.0/255.0, green: 160.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        
        //Query and populate locationData
        //locationData = ParseLocations.getLocationsNearMe(searchedTypes)
        //numLocations = locationData.count
        
        //Query and populate locationData
        restroomData = ParseLocations.getLocationsNearMe(restroomType)
        numRestrooms = restroomData.count
        
        //Query and populate locationData
        barData = ParseLocations.getLocationsNearMe(barType)
        numBars = barData.count
        
        //Query and populate locationData
        buildingData = ParseLocations.getLocationsNearMe(buildingType)
        numBuilding = buildingData.count
        
        //Query and populate locationData
        landmarkData = ParseLocations.getLocationsNearMe(landmarkType)
        numLandmark = landmarkData.count
        
        //Query and populate locationData
        gymData = ParseLocations.getLocationsNearMe(gymType)
        numGym = gymData.count
        
        //Query and populate locationData
        parkingData = ParseLocations.getLocationsNearMe(parkingType)
        numParking = parkingData.count
        
        //Query and populate locationData
        storeData = ParseLocations.getLocationsNearMe(storeType)
        numStore = storeData.count
        
        //Query and populate locationData
        housingData = ParseLocations.getLocationsNearMe(housingType)
        numHousing = housingData.count
        
        //Query and populate locationData
        atmData = ParseLocations.getLocationsNearMe(atmType)
        numAtm = atmData.count
        
        //Query and populate locationData
        restraurantData = ParseLocations.getLocationsNearMe(restraurantType)
        numRestraurant = restraurantData.count
        
        println("Debug: What's nearby View and Data loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 10
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch(section){
        case 0:
            return numRestrooms
        case 1:
            return numBars
        case 2:
            return numLandmark
        case 3:
            return numGym
        case 4:
            return numParking
        case 5:
            return numStore
        case 6:
            return numHousing
        case 7:
            return numAtm
        case 8:
            return numRestraurant
        case 9:
            return numBuilding
        default:
            return 10
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        switch(section){
        case 0:
            return "restrooms"
        case 1:
            return "bars"
        case 2:
            return "landmark"
        case 3:
            return "gym"
        case 4:
            return "parking"
        case 5:
            return "store"
        case 6:
            return "housing"
        case 7:
            return "atm"
        case 8:
            return "restraunt"
        case 9:
            return "building"
        default:
            return "other"
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return locationCellAtIndexPath(indexPath)
    }
    
    func locationCellAtIndexPath(indexPath: NSIndexPath) -> LocationTableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as LocationTableViewCell
        setCellDisplay(cell, indexPath: indexPath)

        return cell
    }
    
    //Helper Function for setting all relevent cell displays
    func setCellDisplay(cell:LocationTableViewCell, indexPath:NSIndexPath) {
        
        switch(indexPath.section){
        case 0:
            assignLabels(restroomData, cell: cell, indexPath: indexPath)
        case 1:
            assignLabels(barData, cell: cell, indexPath: indexPath)
        case 2:
            assignLabels(landmarkData, cell: cell, indexPath: indexPath)
        case 3:
            assignLabels(gymData, cell: cell, indexPath: indexPath)
        case 4:
            assignLabels(parkingData, cell: cell, indexPath: indexPath)
        case 5:
            assignLabels(storeData, cell: cell, indexPath: indexPath)
        case 6:
            assignLabels(housingData, cell: cell, indexPath: indexPath)
        case 7:
            assignLabels(atmData, cell: cell, indexPath: indexPath)
        case 8:
            assignLabels(restraurantData, cell: cell, indexPath: indexPath)
        case 9:
            assignLabels(buildingData, cell: cell, indexPath: indexPath)
        default:
            assignLabels(restroomData, cell: cell, indexPath: indexPath)
        }
        
    }
    
    func assignLabels(locData: [PFObject], cell: LocationTableViewCell, indexPath: NSIndexPath){
        cell.name_label.text = locData[indexPath.row]["name"] as String!
        cell.description_label.text = locData[indexPath.row]["description"] as String!
        cell.category_label.text = locData[indexPath.row]["category"] as String!
        let score = locData[indexPath.row]["avgRank"] as Int!
        if( score != nil){
            cell.score_label.text = String(score)
        }
    }

}
