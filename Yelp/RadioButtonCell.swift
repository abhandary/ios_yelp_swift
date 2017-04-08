
//
//  RadioButtonCell.swift
//  Yelp
//
//  Created by Akshay Bhandary on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import DLRadioButton

@objc protocol RadioButtonCellDelegate {
    func radioButtonSelected(sender : RadioButtonCell);
}

class RadioButtonCell: UITableViewCell {

    weak var delegate : RadioButtonCellDelegate?
    
    @IBOutlet weak var radioButtonLabel: UILabel!
    @IBOutlet weak var radioButton: DLRadioButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonSelected(_ sender: DLRadioButton) {
        self.delegate?.radioButtonSelected(sender: self)
    }
}
