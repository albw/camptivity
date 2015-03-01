//
//  FeedTableViewCell.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 2/28/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var description_label: UILabel!
    @IBOutlet var title_label: UILabel!
    @IBOutlet var profile_image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
