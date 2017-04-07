
//
//  RadioButtonCell.swift
//  Yelp
//
//  Created by Akshay Bhandary on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class RadioButtonCell: UITableViewCell {

    @IBOutlet weak var radioButtonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
