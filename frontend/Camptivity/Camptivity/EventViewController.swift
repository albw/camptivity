//
//  EventViewController.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 3/3/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("In Event View")
        println(name)

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
