//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var searchBar : UISearchBar!
    var businesses: [Business]?
    
    var nameToBusiness  = [String : Business] ()
    var settings  = Settings()
    
    // infinite scroll related
    var isMoreDataLoading = false
    var loadLimit         = 20
    var loadMoreOffset    = 21
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup map view
        self.mapView.delegate = self
        
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
            // self.tableView.reloadData()
            self.reloadListAndMapViews()
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
    // MARK: - Do Search
    func doSearch(offset : Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var radius : Int? = nil
        if self.settings.distanceSelectedIndex > 0 {
            radius = self.settings.distanceInMeters[self.settings.distanceSelectedIndex]
        }
        
        Business.searchWithTerm(term: self.settings.searchString, sort: YelpSortMode(rawValue:self.settings.sortBySelectedIndex)!, categories: Array(self.settings.selectedCategories), deals: self.settings.offeringADeal, radius:radius, offset:offset) { (businesses, error) in
            self.isMoreDataLoading = false
            if error != nil || businesses == nil {
                MBProgressHUD.hide(for: self.view, animated: true)
                print(error)
                // @todo: show no results found message
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                if offset == 0 {
                    self.businesses = businesses
                } else {
                    self.businesses?.append(contentsOf: businesses!)
                }
                // self.tableView.reloadData()
                self.reloadListAndMapViews()
            }
        }
        
    }
    
    // MARK: - Reload List and Map Views
    func reloadListAndMapViews() {
        
        // reload table view
        self.tableView.reloadData()
        
        // add annotations to map view
        var coordinate = CLLocationCoordinate2DMake(37.0,-122.0);
        var annotation = MKPointAnnotation()
        self.mapView.removeAnnotations(self.mapView.annotations);
        if let businesses = self.businesses {
            for business in businesses {
                if let lat = business.lat,
                    let lon = business.lon {
                    coordinate = CLLocationCoordinate2DMake(lat, lon)
                    annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = business.name
                    annotation.subtitle = business.address
                    
                    // var placemark = MKPlacemark(coordinate: coordinate , addressDictionary: nil);
                    // placemark.title = business.name
                    self.nameToBusiness[annotation.title! + annotation.subtitle!] = business
                    self.mapView.addAnnotation(annotation)

                }
            }
            
            self.mapView.selectAnnotation(annotation, animated: true);
            let  viewRegion =
                MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
            let adjustedRegion = self.mapView.regionThatFits(viewRegion)
            self.mapView.setRegion(adjustedRegion, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell;
        cell.business = self.businesses?[indexPath.row];
        return cell;
    }
    
    
    // enable inifite scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // load more results
                doSearch(offset: loadMoreOffset)
                loadMoreOffset += loadLimit
            }
        }
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
            loadMoreOffset = loadLimit + 1 // reset the offset back
            doSearch(offset: 0)
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
            if let cell = sender as? BusinessCell {
                self.tableView.deselectRow(at: self.tableView.indexPath(for: cell)!, animated: true)
                detailVC.business = self.businesses![(self.tableView.indexPath(for: cell)!.row)]
                detailVC.ratingsImage = cell.starsImageView.image
            } else if let view = sender as? MKPinAnnotationView {
                if let business = nameToBusiness[view.annotation!.title!! + view.annotation!.subtitle!!] {
                    detailVC.business = business
                }
            }
        }
    }
    
    
    // MARK: - Map View Related
    
    @IBAction func mapButtonBarClicked(_ sender: UIBarButtonItem) {
        
        if sender.title == "Map" {
            let transitionParams :  UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(from: self.tableView,
                              to: self.mapView,
                              duration: 0.5,
                              options: transitionParams,
                              completion: nil);
        } else {
            let transitionParams :  UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(from: self.mapView,
                              to: self.tableView,
                              duration: 0.5,
                              options: transitionParams,
                              completion: nil);
        }
        sender.title = sender.title == "List" ? "Map" : "List"
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "loc")
        
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        // annotationView.image = UIImage(named: "phone.png")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        self.performSegue(withIdentifier: "showDetailSegue", sender: view)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        loadMoreOffset = loadLimit + 1 // reset the offset back        
        doSearch(offset: 0)
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
