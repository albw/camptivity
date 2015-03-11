//
//  FeedTableViewCell.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 2/28/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var username_label: UILabel!
    @IBOutlet var description_label: UILabel!
    @IBOutlet var title_label: UILabel!
    @IBOutlet var profile_image: UIImageView!
    
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var up_button: UIButton!
    @IBOutlet weak var down_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
