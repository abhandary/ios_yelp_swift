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
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchButtonClicked(_ sender: UIButton) {
        
        UIView.transition(with: sender,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: {
            sender.isSelected = !sender.isSelected
            }, completion: nil);
        
        self.delegate?.switchStateChanged(sender: self, state: sender.isSelected )
    }
    @IBAction func switchStateChanged(_ sender: UISwitch) {
        self.delegate?.switchStateChanged(sender: self, state: sender.isOn)
    }
}
