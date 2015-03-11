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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar
        var image: UIImage = UIImage(named: "purplesky")!
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)

        //Query and populate locationData
        //ParseLocations.getLocationsNearMe()
        
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
        return 200
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return locationCellAtIndexPath(indexPath)
    }
    
    func locationCellAtIndexPath(indexPath: NSIndexPath) -> LocationTableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as LocationTableViewCell
        if(indexPath.row < 200){ //Currently hardcoded, need a way to determine the amount of events
            //setCellDisplay(cell, indexPath: indexPath)
        }
        return cell
    }
    
    //Helper Function for setting all relevent cell displays
    /*func setCellDisplay(cell:LocationTableViewCell, indexPath:NSIndexPath) {
        cell.name_label =
        cell.description_label =
        cell.image_label =
        cell.category_label =
        cell.avgrank_label =
    }*/

}
