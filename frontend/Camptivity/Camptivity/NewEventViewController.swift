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

class NewEventViewController: UIViewController, UIAlertViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var location = CLLocationCoordinate2DMake(0,0)
    var imagePickerController = UIImagePickerController()
    let dataProvide = ParseDataProvider()
    
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
        
        //dataProvide.postEvent(eventName, user: "", desc: eventDescription, start: startDate as NSString, expires: endDate as NSString)
        
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
    
    @IBAction func btnClicked(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Button capture")
            
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePickerController.allowsEditing = false
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imagePicker.image = image
    }
    
}