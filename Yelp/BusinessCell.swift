//
//  BusinessCell.swift
//  Yelp
//
//  Created by Akshay Bhandary on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {


    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var starsImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var typeOfBusinessLabel: UILabel!
    
    var business : Business? {
        didSet {
            self.name.text = business?.name
            self.addressLabel.text = business?.address
            self.distanceLabel.text = business?.distance
            if let reviewCount = business?.reviewCount {
                self.reviewsLabel.text = reviewCount.stringValue + "reviews"
            } else {
                self.reviewsLabel.text = "0 reviews"
            }
            
            self.starsImageView.image = nil;
            if let url = business?.ratingImageURL {
                self.starsImageView.setImageWith(url)
            }
            
            self.thumbnailImage.image = nil;
            if let url = business?.imageURL {
                self.thumbnailImage.setImageWith(url);
                
                self.thumbnailImage.layer.cornerRadius = 5
                self.thumbnailImage.clipsToBounds = true;
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
