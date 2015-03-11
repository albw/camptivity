//
//  LocationTableViewCell.swift
//  Camptivity
//
//  Created by Shayan Mahdavi on 3/11/15.
//  Copyright (c) 2015 Camptivity INC. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    //name
    //description
    //AvgRank
    //Image
    //Category

    @IBOutlet weak var score_label: UILabel!
    @IBOutlet weak var category_label: UILabel!
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
