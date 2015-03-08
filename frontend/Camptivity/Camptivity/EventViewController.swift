//
//  EventViewController.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 3/3/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var title_label: UILabel!
    
    let pin_button = UIButton.buttonWithType(UIButtonType.System) as UIButton
    
    var name: String!
    var details: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("In Event View")
        println(name)
        println(details)
        
        title_label.text = name
        description_label.text = details
        
        pin_button.frame = CGRectMake(100, 100, 100, 50)
        pin_button.setTitle("Pin to Map", forState: UIControlState.Normal)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let buttonX = (screenSize.width/2) - 50
        let buttonY = screenSize.height - 200
        
        pin_button.frame = CGRectMake(buttonX, buttonY, 100, 50)
        
        self.view.addSubview(pin_button)

        let comment_button = UIBarButtonItem(title: "Comment", style: .Done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = comment_button
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
