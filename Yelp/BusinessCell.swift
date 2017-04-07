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
    @IBOutlet weak var categories: UILabel!
    
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
                self.thumbnailImage.setImageWith(URLRequest(url: url), placeholderImage: nil,
                                                 success: { (urlRequest, imageResponse, image) in
                                                    if imageResponse != nil {
                                                        
                                                        self.thumbnailImage?.alpha = 0.0
                                                        self.thumbnailImage?.image = image
                                                        self.thumbnailImage?.contentMode = UIViewContentMode.scaleToFill
                                                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                                            self.thumbnailImage?.alpha = 1.0
                                                        })
                                                    } else {
                                                        
                                                        self.thumbnailImage?.image = image
                                                        self.thumbnailImage?.contentMode = UIViewContentMode.scaleToFill
                                                    }
                    }, failure: { (urlRequest, urlResponse, error) in
                        
                })
                
                self.thumbnailImage.layer.cornerRadius = 5
                self.thumbnailImage.clipsToBounds = true;
            }
            
            self.categories.text = business?.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.name.preferredMaxLayoutWidth = self.name.frame.width
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
       // self.name.preferredMaxLayoutWidth = self.name.frame.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
