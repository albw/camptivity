//
//  NewEventViewController.swift
//  Camptivity
//
//  Created by SI  on 2/24/15.
//  Update by Phuong Mai on 3/9/15
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit
import ParseUI


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
    //Reference to middleware function calls

    weak var delegate: NewEventViewControllerDelegate?
    
    @IBAction func addButtonClicked(sender: UIBarButtonItem) {
        var eventImage = imagePicker.image
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
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        var startDateString = dateFormatter.stringFromDate(startDate)
        var endDateString = dateFormatter.stringFromDate(endDate)
        
        
        ParseEvents.postEvent(eventName, desc: eventDescription, lat: location.latitude, lon: location.longitude, user: PFUser.currentUser().username, start: startDateString, expires: startDateString)
        
        // load back object to get objectId, because upload icom need objectId
        var obj = ParseEvents.getEventByName(eventName)
        
        var imageData = NSData()
        imageData = UIImageJPEGRepresentation(self.imagePicker.image, 0.8)
        var imageFile = PFFile(data:imageData)
        let dataprovider = ParseDataProvider()
        dataprovider.saveIcon("Events", objID: obj.objectId, colName: "icon", img: imageFile)
            
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