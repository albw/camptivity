//
//  LocationTableViewController.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 3/11/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    var locationData: [PFObject]!
    var numLocations = 0
    
    var searchedTypes = ["restroom", "bar", "building", "landmark", "gym", "parking", "store", "housing", "atm", "restraurant"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar
        //var image: UIImage = UIImage(named: "purplesky")!
        //self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
        //Query and populate locationData
        //var restroomType = ["restroom"]
        locationData = ParseLocations.getLocationsNearMe(searchedTypes)
        numLocations = locationData.count
        
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return numLocations
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        println("Feeding Cell")
        return locationCellAtIndexPath(indexPath)
    }
    
    func locationCellAtIndexPath(indexPath: NSIndexPath) -> LocationTableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as LocationTableViewCell
        if(indexPath.row < numLocations){ //Currently hardcoded, need a way to determine the amount of events
            setCellDisplay(cell, indexPath: indexPath)
        }
        return cell
    }
    
    //Helper Function for setting all relevent cell displays
    func setCellDisplay(cell:LocationTableViewCell, indexPath:NSIndexPath) {
        println("Setting labels")
        cell.name_label.text = locationData[indexPath.row]["name"] as String!
        cell.description_label.text = locationData[indexPath.row]["description"] as String!
        //cell.image_label.text =
        cell.category_label.text = locationData[indexPath.row]["category"] as String!
        let score = locationData[indexPath.row]["avgRank"] as Int!
        if( score != nil){
          cell.score_label.text = String(score)
        }
        println("Labels Set")
    }

}
