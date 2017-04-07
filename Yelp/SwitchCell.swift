//
//  SwitchCell.swift
//  Yelp
//
//  Created by Akshay Bhandary on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    func switchStateChanged(sender : SwitchCell, state : Bool)
}

class SwitchCell: UITableViewCell {

    weak var delegate : SwitchCellDelegate?
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchStateChanged(_ sender: UISwitch) {
        self.delegate?.switchStateChanged(sender: self, state: sender.isOn)
    }
}
