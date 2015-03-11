//
//  MapViewController.swift
//  Feed Me
//
//  Created by Si Li on 8/30/14.
//  Copyright (c) 2014 Camptivity INC. All rights reserved.
//

import UIKit

protocol TypesTableViewControllerDelegate: class {
    func typesController(controller: TypesTableViewController, didSelectTypes types: [String])
}

class TypesTableViewController: UITableViewController {
    
    let possibleTypesDictionary = ["atm":"atm", "bar":"bar", "building":"building", "gym":"gym", "housing":"housing", "landmark":"landmark", "library":"library", "parking":"parking", "restaurant":"restaurant", "restroom":"restroom", "store":"store", "water":"water"]
    var selectedTypes: [String]!
    weak var delegate: TypesTableViewControllerDelegate!
    var sortedKeys: [String] {
        get {
            return sorted(possibleTypesDictionary.keys)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        //self.tableView.tableFooterView.hidden = true
        self.tableView.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: - Actions
    @IBAction func donePressed(sender: AnyObject) {
        delegate?.typesController(self, didSelectTypes: selectedTypes)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleTypesDictionary.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TypeCell", forIndexPath: indexPath) as UITableViewCell
        let key = sortedKeys[indexPath.row]
        let type = possibleTypesDictionary[key]!
    cell.textLabel?.text = type
    cell.imageView?.image = UIImage(named: key)
    cell.accessoryType = contains(selectedTypes!, key) ? .Checkmark : .None
    return cell
  }
  
  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let key = sortedKeys[indexPath.row]
    if contains(selectedTypes!, key) {
      selectedTypes = selectedTypes.filter({$0 != key})
    } else {
      selectedTypes.append(key)
    }
    
    tableView.reloadData()
  }
}
