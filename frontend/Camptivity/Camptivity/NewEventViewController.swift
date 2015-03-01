//
//  NewEventViewController.swift
//  Camptivity
//
//  Created by SI  on 2/24/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

protocol NewEventViewControllerDelegate: class
{
    func didCreateEventAtCoordinate( name: NSString, Description: NSString, coordinate: CLLocationCoordinate2D )
}

class NewEventViewController: UIViewController, UIAlertViewDelegate {
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var location = CLLocationCoordinate2DMake(0,0)
    
    weak var delegate: NewEventViewControllerDelegate?
    
    @IBAction func addButtonClicked(sender: UIBarButtonItem) {
        var eventName = eventNameTextField.text
        var eventDescription = eventDescriptionTextView.text
        var startDate = startDatePicker.date
        var endDate = endDatePicker.date
        let alert = UIAlertView()
        alert.title = "Success"
        alert.message = "Your event has been uploaded!"
        alert.addButtonWithTitle("Back to Map")
        alert.delegate = self
        alert.show()
        
        delegate?.didCreateEventAtCoordinate(eventName, Description: eventDescription, coordinate: location)
        
        NSLog("%@", eventName)
        NSLog("%@", eventDescription)
        NSLog("%@", startDate)
        NSLog("%@", endDate)
        
        //geolocation
        NSLog("%f", location.longitude)
        NSLog("%f", location.latitude)
    }
    
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 0 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}