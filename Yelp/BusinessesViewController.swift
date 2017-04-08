//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var searchBar : UISearchBar!
    var businesses: [Business]?
    
    var settings  = Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // setup search bar
        searchBar = UISearchBar();
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        
        // setup table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // initiate basic search
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                   // print(business.name!)
                   // print(business.address!)
                    print(business.ratingImageURL)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    func doSearch() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var radius : Int? = nil
        if self.settings.distanceSelectedIndex > 0 {
            radius = self.settings.distanceInMeters[self.settings.distanceSelectedIndex]
        }
        
        Business.searchWithTerm(term: self.settings.searchString, sort: YelpSortMode(rawValue:self.settings.sortBySelectedIndex)!, categories: Array(self.settings.selectedCategories), deals: self.settings.offeringADeal, radius:radius) { (businesses, error) in
            if let error = error {
                MBProgressHUD.hide(for: self.view, animated: true)
                print(error)
                // @todo: show no results found message
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell;
        cell.business = self.businesses?[indexPath.row];
        return cell;
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation

    
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetailSegue" {
//            let detailVC = segue.destination as! DetailTableViewController
//            let cell = sender as! UITableViewCell
//            detailVC.business = self.businesses![(self.tableView.indexPath(for: cell)!.row)]
//        }
//     }

    
    @IBAction func unWindFromSettings(segue : UIStoryboardSegue) {
        if segue.identifier == "searchSegue" {
            let fvc = segue.source as! FiltersViewController
            self.settings = fvc.settings
            doSearch()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "presentFiltersSegue" {
            let nvc = segue.destination as! UINavigationController
            let fvc = nvc.topViewController as! FiltersViewController
            fvc.settings = self.settings
        }
        else if segue.identifier == "showDetailSegue" {
            let detailVC = segue.destination as! DetailTableViewController
            let cell = sender as! BusinessCell
            self.tableView.deselectRow(at: self.tableView.indexPath(for: cell)!, animated: true)
            detailVC.business = self.businesses![(self.tableView.indexPath(for: cell)!.row)]
            detailVC.ratingsImage = cell.starsImageView.image
        }
    }
    
}

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        settings.searchString = searchBar.text!
        searchBar.resignFirstResponder()
        doSearch()
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
