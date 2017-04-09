//
//  DetailTableViewController.swift
//  Yelp
//
//  Created by Akshay Bhandary on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit




class DetailTableViewController: UITableViewController {

    var business : Business!
    var ratingsImage : UIImage?

    
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var topSectionContentView: UIView!
    @IBOutlet weak var topSectionFirstHalfView: UIView!
    @IBOutlet weak var topSectionSecondHalfView: UIView!
    
    @IBOutlet weak var callCell: UITableViewCell!
    
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var snippetText: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.name.text = business.name
        if ratingsImage != nil {
            self.ratingsImageView.image = ratingsImage
        } else {
            self.ratingsImageView.setImageWith(business.ratingImageURL!)
        }
        self.address.text = business.address
        
        if let distance = business.distance {
            self.distance.text = distance
        }
        
        self.snippetText.text = " 👤 " + business.snippetText!
        self.phoneNumber.text = business.displayPhone
        
        if let reviewCountNum = business.reviewCount {
            self.reviewCount.text = "\(reviewCountNum) Reviews"
        }
        
        if let lat = business.lat,
            let lon = business.lon {
            let coordinate = CLLocationCoordinate2DMake(lat, lon)
            let placemark = MKPlacemark(coordinate: coordinate , addressDictionary: nil);
            self.mapView.addAnnotation(placemark)
            
            let  viewRegion =
                MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
            let adjustedRegion = self.mapView.regionThatFits(viewRegion)
            self.mapView.setRegion(adjustedRegion, animated: true)
        }

        // set the thumbnail view for the top half and set a transparency/blur effect
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            if let thumbnailImageURL = self.business.imageURL {
                self.thumbnailImageView.setImageWith(thumbnailImageURL)
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
                blurEffectView.effect = blurEffect
                self.blurEffectView.alpha = 0.6
            }
        }
        
        // set a border on the map view
        self.mapView.layer.borderColor = UIColor.gray.cgColor
        self.mapView.layer.borderWidth = 0.3
        
        // set a border on the call cell
       // self.callCell.layer.borderColor = UIColor.gray.cgColor
       // self.callCell.layer.borderWidth = 0.3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            // place call
         
            if var phone = business.displayPhone {
                let index = phone.index(phone.startIndex, offsetBy: 1);
                phone = phone.substring(from: index)
                let telURL = URL(string: "tel:" + phone)
                if UIApplication.shared.canOpenURL(telURL!) {
                    UIApplication.shared.openURL(telURL!)
                }
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        print(self.topSectionFirstHalfView)
        print(self.topSectionContentView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else if section == 1{
            return 30;
        }
        return 0
    }
    
}
