//
//  SignUpViewController.swift
//  Camptivity
//
//  Created by Khoa Nguyen on 2/10/15.
//  Updated by Phuong Mai on 3/3/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit
import MobileCoreServices


class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet var imgView: UIImageView!
    
    @IBAction func loginVerifyButton(sender: AnyObject) {
        var usrEntered = userName.text
        var pwdEntered = userPassword.text
        var emlEntered = userEmail.text
        var nameEntered = fullName.text
        
        if usrEntered != "" && pwdEntered != "" && emlEntered != "" {
            let provider = ParseDataProvider()
            var s  = provider.newUserSignup(usrEntered, password:pwdEntered, email:emlEntered, fullname: nameEntered)
            
            var imageData = NSData()
            imageData = UIImageJPEGRepresentation(self.imgView.image, 0.8)
            
            provider.saveImageToPictureProfile(usrEntered, password: pwdEntered, imageFile: PFFile(data:imageData))
            
            let alert = UIAlertView()
            alert.title = "Signed Up"
            alert.message = "Successfully signed up on Parse"
            alert.delegate = self
            alert.addButtonWithTitle("Ok")
            alert.show()

        } else {
            //self.messageLabel.text = "All Fields Required"
        }
        
    }
    
    
    @IBAction func btnAddImage(sender: AnyObject) {
        showPhotoLibary()
    }
    func showPhotoLibary()-> Void
    {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) == false) {
            return;
        }
        var mediaUI = UIImagePickerController()
        mediaUI.delegate = self
        mediaUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeImage]
        mediaUI.allowsEditing = false
        self.presentViewController(mediaUI, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        
        self.imgView.image = selectedImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}


