//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Akshay Bhandary on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

public struct Settings {
    
    var searchString  = "Restaurants"
    
    var seeAll = false
    var bestMatchExpanded = false;
    var sortByExpanded = false;
    var distanceExpanded = false;
    var offeringADeal = false;
    
    var distanceSelectedIndex = 0
    let distances = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"];
    let distanceInMeters = [0, 483, 1609, 8047, 40000]
    
    var sortBySelectedIndex = 0
    let sortBy = ["Best Match", "Distance", "Highest Rated"];
    
    var categorySelectedIndex = -1;
    
    var selectedCategories = Set<String>()
}

enum TableViewSection : Int {
   case deal = 0
   case distance = 1
   case sortBy = 2
   case category = 3
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate, RadioButtonCellDelegate {

    var categories : [[String:String]]!

    var settings = Settings()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.categories = yelpCategories()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 50
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionEnum = TableViewSection(rawValue: section)!
        
        switch sectionEnum {
            
        case .deal:
            return 1;
        case .distance:
            return self.settings.distanceExpanded ? 5 : 1
        case .sortBy:
            return self.settings.sortByExpanded ? 3 : 1
        case .category:
            return self.settings.seeAll ?  self.categories.count + 1 : 4
        }
       
    }
    
    func dealCell () -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell;
        cell.switchLabel.text = "Offering a Deal"
        cell.delegate = self
        cell.switchButton.isOn = self.settings.offeringADeal
        cell.selectionStyle = .none
        return cell
    }
    
    func distanceCell(indexPath : IndexPath) -> UITableViewCell {
        if self.settings.distanceExpanded == false {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandCell
            cell.expandLabel.text = self.settings.distances[self.settings.distanceSelectedIndex]
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as! RadioButtonCell
            cell.delegate = self
            cell.radioButtonLabel.text = self.settings.distances[indexPath.row]
            cell.radioButton.isSelected = self.settings.distanceSelectedIndex == indexPath.row ? true : false
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func sortByCell(indexPath : IndexPath) -> UITableViewCell {
        if self.settings.sortByExpanded == false {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandCell
            cell.expandLabel.text = self.settings.sortBy[self.settings.sortBySelectedIndex]
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as! RadioButtonCell
            cell.delegate = self
            cell.radioButtonLabel.text = self.settings.sortBy[indexPath.row]
            cell.radioButton.isSelected = self.settings.sortBySelectedIndex == indexPath.row ? true : false
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func categoriesCell(indexPath : IndexPath) -> UITableViewCell {
        if self.settings.seeAll == false {
            if indexPath.row >= 0 && indexPath.row < 3 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell

                cell.selectionStyle = .none
                cell.delegate = self

                
                // set the lable text
                cell.switchLabel.text = self.categories[indexPath.row]["name"]
                
                // set the switch state
                if self.settings.selectedCategories.contains(self.categories[indexPath.row]["code"]!) {
                    cell.switchButton.isOn = true
                } else {
                    cell.switchButton.isOn = false
                }
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "SeeMoreCell") as! SeeMoreCell
                cell.seeMoreLabel.text =  "See More"
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if indexPath.row >= 1 && indexPath.row <= self.categories.count {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell

                cell.selectionStyle = .none
                cell.delegate = self
                
                // set the lable text
                cell.switchLabel.text = self.categories[indexPath.row - 1]["name"]
                
                // set the switch state
                if self.settings.selectedCategories.contains(self.categories[indexPath.row]["code"]!) {
                    cell.switchButton.isOn = true
                } else {
                    cell.switchButton.isOn = false
                }
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "SeeMoreCell") as! SeeMoreCell
                cell.seeMoreLabel.text =  "See Less"
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionEnum = TableViewSection(rawValue: indexPath.section)!
        switch sectionEnum {
        case .deal:
            return dealCell()
        case .distance:
            return distanceCell(indexPath: indexPath)
        case .sortBy:
            return sortByCell(indexPath: indexPath)
        case .category:
            return categoriesCell(indexPath : indexPath)
        }
    }
    
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionEnum = TableViewSection(rawValue: section)!
        switch sectionEnum {
        case .deal:
            return nil
        case .distance:
            return "Distance"
        case .sortBy:
            return "Sort By"
        case .category:
            return "Category"
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func distanceSectionSelected(indexPath : IndexPath) {
        // 1. save the distance selected index if section is expanded
        if self.settings.distanceExpanded == true {
            self.settings.distanceSelectedIndex = indexPath.row
        }
        
        // 2. toggle distance section
        self.settings.distanceExpanded = !self.settings.distanceExpanded;
        
        // 3. reload table with animation
        let indexSet = IndexSet(integer: indexPath.section)
        self.tableView.reloadSections(indexSet, with: .fade)
    }
    
    func sortBySectionSelected(indexPath : IndexPath) {
        
        // 1. save the sort by selected index if section is expanded
        if self.settings.sortByExpanded == true {
            self.settings.sortBySelectedIndex = indexPath.row
        }
        
        // 2. toggle the sort by section
        self.settings.sortByExpanded = !self.settings.sortByExpanded;
        
        // 3. reload table with animation
        let indexSet = IndexSet(integer: indexPath.section)
        self.tableView.reloadSections(indexSet, with: .fade)
    }
    
    func  categorySectionSelected(indexPath : IndexPath) {

        // if this is a toggle request then toggle the seeAll bool
        if (self.settings.seeAll == false && indexPath.row == 3) ||
            (self.settings.seeAll == true  && indexPath.row == 0) {
            self.settings.seeAll = !self.settings.seeAll
            let indexSet = IndexSet(integer: indexPath.section)
            self.tableView.reloadSections(indexSet, with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionEnum = TableViewSection(rawValue: indexPath.section)!
        
        if sectionEnum == .distance {
            distanceSectionSelected(indexPath: indexPath)
        } else if sectionEnum == .sortBy {
            sortBySectionSelected(indexPath: indexPath)
        } else if sectionEnum == .category {
            categorySectionSelected(indexPath: indexPath)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - SwitchCellDelegate
    func switchStateChanged(sender: SwitchCell, state: Bool) {
        if let indexPath = self.tableView.indexPath(for: sender) {
            let sectionEnum = TableViewSection(rawValue: indexPath.section)
            if sectionEnum == .deal {
                self.settings.offeringADeal = state
            } else if sectionEnum == .category {
                if state == true {
                    self.settings.selectedCategories.insert(self.categories[indexPath.row]["code"]!)
                } else {
                    self.settings.selectedCategories.remove(self.categories[indexPath.row]["code"]!)
                }
            }
        }
    }
    
    // MARK: - RadioButtonCellDelegate
    func radioButtonSelected(sender: RadioButtonCell) {
        
        // save the selected and collapse the section
        if let indexPath = self.tableView.indexPath(for: sender),
            let sectionEnum = TableViewSection(rawValue: indexPath.section) {
            if sectionEnum == .distance {
                self.settings.distanceSelectedIndex = indexPath.row
                self.settings.distanceExpanded = false
            } else if sectionEnum == .sortBy {
                self.settings.sortBySelectedIndex = indexPath.row
                self.settings.sortByExpanded = false
            }
            let indexSet = IndexSet(integer: indexPath.section)
            self.tableView.reloadSections(indexSet, with: .fade)
        }
    }
    
    
    func yelpCategories() -> [[String:String]] {
        return   [["name" : "Afghan", "code": "afghani"],
                  ["name" : "African", "code": "african"],
                  ["name" : "American, New", "code": "newamerican"],
                  ["name" : "American, Traditional", "code": "tradamerican"],
                  ["name" : "Arabian", "code": "arabian"],
                  ["name" : "Argentine", "code": "argentine"],
                  ["name" : "Armenian", "code": "armenian"],
                  ["name" : "Asian Fusion", "code": "asianfusion"],
                  ["name" : "Asturian", "code": "asturian"],
                  ["name" : "Australian", "code": "australian"],
                  ["name" : "Austrian", "code": "austrian"],
                  ["name" : "Baguettes", "code": "baguettes"],
                  ["name" : "Bangladeshi", "code": "bangladeshi"],
                  ["name" : "Barbeque", "code": "bbq"],
                  ["name" : "Basque", "code": "basque"],
                  ["name" : "Bavarian", "code": "bavarian"],
                  ["name" : "Beer Garden", "code": "beergarden"],
                  ["name" : "Beer Hall", "code": "beerhall"],
                  ["name" : "Beisl", "code": "beisl"],
                  ["name" : "Belgian", "code": "belgian"],
                  ["name" : "Bistros", "code": "bistros"],
                  ["name" : "Black Sea", "code": "blacksea"],
                  ["name" : "Brasseries", "code": "brasseries"],
                  ["name" : "Brazilian", "code": "brazilian"],
                  ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                  ["name" : "British", "code": "british"],
                  ["name" : "Buffets", "code": "buffets"],
                  ["name" : "Bulgarian", "code": "bulgarian"],
                  ["name" : "Burgers", "code": "burgers"],
                  ["name" : "Burmese", "code": "burmese"],
                  ["name" : "Cafes", "code": "cafes"],
                  ["name" : "Cafeteria", "code": "cafeteria"],
                  ["name" : "Cajun/Creole", "code": "cajun"],
                  ["name" : "Cambodian", "code": "cambodian"],
                  ["name" : "Canadian", "code": "New)"],
                  ["name" : "Canteen", "code": "canteen"],
                  ["name" : "Caribbean", "code": "caribbean"],
                  ["name" : "Catalan", "code": "catalan"],
                  ["name" : "Chech", "code": "chech"],
                  ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                  ["name" : "Chicken Shop", "code": "chickenshop"],
                  ["name" : "Chicken Wings", "code": "chicken_wings"],
                  ["name" : "Chilean", "code": "chilean"],
                  ["name" : "Chinese", "code": "chinese"],
                  ["name" : "Comfort Food", "code": "comfortfood"],
                  ["name" : "Corsican", "code": "corsican"],
                  ["name" : "Creperies", "code": "creperies"],
                  ["name" : "Cuban", "code": "cuban"],
                  ["name" : "Curry Sausage", "code": "currysausage"],
                  ["name" : "Cypriot", "code": "cypriot"],
                  ["name" : "Czech", "code": "czech"],
                  ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                  ["name" : "Danish", "code": "danish"],
                  ["name" : "Delis", "code": "delis"],
                  ["name" : "Diners", "code": "diners"],
                  ["name" : "Dumplings", "code": "dumplings"],
                  ["name" : "Eastern European", "code": "eastern_european"],
                  ["name" : "Ethiopian", "code": "ethiopian"],
                  ["name" : "Fast Food", "code": "hotdogs"],
                  ["name" : "Filipino", "code": "filipino"],
                  ["name" : "Fish & Chips", "code": "fishnchips"],
                  ["name" : "Fondue", "code": "fondue"],
                  ["name" : "Food Court", "code": "food_court"],
                  ["name" : "Food Stands", "code": "foodstands"],
                  ["name" : "French", "code": "french"],
                  ["name" : "French Southwest", "code": "sud_ouest"],
                  ["name" : "Galician", "code": "galician"],
                  ["name" : "Gastropubs", "code": "gastropubs"],
                  ["name" : "Georgian", "code": "georgian"],
                  ["name" : "German", "code": "german"],
                  ["name" : "Giblets", "code": "giblets"],
                  ["name" : "Gluten-Free", "code": "gluten_free"],
                  ["name" : "Greek", "code": "greek"],
                  ["name" : "Halal", "code": "halal"],
                  ["name" : "Hawaiian", "code": "hawaiian"],
                  ["name" : "Heuriger", "code": "heuriger"],
                  ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                  ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                  ["name" : "Hot Dogs", "code": "hotdog"],
                  ["name" : "Hot Pot", "code": "hotpot"],
                  ["name" : "Hungarian", "code": "hungarian"],
                  ["name" : "Iberian", "code": "iberian"],
                  ["name" : "Indian", "code": "indpak"],
                  ["name" : "Indonesian", "code": "indonesian"],
                  ["name" : "International", "code": "international"],
                  ["name" : "Irish", "code": "irish"],
                  ["name" : "Island Pub", "code": "island_pub"],
                  ["name" : "Israeli", "code": "israeli"],
                  ["name" : "Italian", "code": "italian"],
                  ["name" : "Japanese", "code": "japanese"],
                  ["name" : "Jewish", "code": "jewish"],
                  ["name" : "Kebab", "code": "kebab"],
                  ["name" : "Korean", "code": "korean"],
                  ["name" : "Kosher", "code": "kosher"],
                  ["name" : "Kurdish", "code": "kurdish"],
                  ["name" : "Laos", "code": "laos"],
                  ["name" : "Laotian", "code": "laotian"],
                  ["name" : "Latin American", "code": "latin"],
                  ["name" : "Live/Raw Food", "code": "raw_food"],
                  ["name" : "Lyonnais", "code": "lyonnais"],
                  ["name" : "Malaysian", "code": "malaysian"],
                  ["name" : "Meatballs", "code": "meatballs"],
                  ["name" : "Mediterranean", "code": "mediterranean"],
                  ["name" : "Mexican", "code": "mexican"],
                  ["name" : "Middle Eastern", "code": "mideastern"],
                  ["name" : "Milk Bars", "code": "milkbars"],
                  ["name" : "Modern Australian", "code": "modern_australian"],
                  ["name" : "Modern European", "code": "modern_european"],
                  ["name" : "Mongolian", "code": "mongolian"],
                  ["name" : "Moroccan", "code": "moroccan"],
                  ["name" : "New Zealand", "code": "newzealand"],
                  ["name" : "Night Food", "code": "nightfood"],
                  ["name" : "Norcinerie", "code": "norcinerie"],
                  ["name" : "Open Sandwiches", "code": "opensandwiches"],
                  ["name" : "Oriental", "code": "oriental"],
                  ["name" : "Pakistani", "code": "pakistani"],
                  ["name" : "Parent Cafes", "code": "eltern_cafes"],
                  ["name" : "Parma", "code": "parma"],
                  ["name" : "Persian/Iranian", "code": "persian"],
                  ["name" : "Peruvian", "code": "peruvian"],
                  ["name" : "Pita", "code": "pita"],
                  ["name" : "Pizza", "code": "pizza"],
                  ["name" : "Polish", "code": "polish"],
                  ["name" : "Portuguese", "code": "portuguese"],
                  ["name" : "Potatoes", "code": "potatoes"],
                  ["name" : "Poutineries", "code": "poutineries"],
                  ["name" : "Pub Food", "code": "pubfood"],
                  ["name" : "Rice", "code": "riceshop"],
                  ["name" : "Romanian", "code": "romanian"],
                  ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                  ["name" : "Rumanian", "code": "rumanian"],
                  ["name" : "Russian", "code": "russian"],
                  ["name" : "Salad", "code": "salad"],
                  ["name" : "Sandwiches", "code": "sandwiches"],
                  ["name" : "Scandinavian", "code": "scandinavian"],
                  ["name" : "Scottish", "code": "scottish"],
                  ["name" : "Seafood", "code": "seafood"],
                  ["name" : "Serbo Croatian", "code": "serbocroatian"],
                  ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                  ["name" : "Singaporean", "code": "singaporean"],
                  ["name" : "Slovakian", "code": "slovakian"],
                  ["name" : "Soul Food", "code": "soulfood"],
                  ["name" : "Soup", "code": "soup"],
                  ["name" : "Southern", "code": "southern"],
                  ["name" : "Spanish", "code": "spanish"],
                  ["name" : "Steakhouses", "code": "steak"],
                  ["name" : "Sushi Bars", "code": "sushi"],
                  ["name" : "Swabian", "code": "swabian"],
                  ["name" : "Swedish", "code": "swedish"],
                  ["name" : "Swiss Food", "code": "swissfood"],
                  ["name" : "Tabernas", "code": "tabernas"],
                  ["name" : "Taiwanese", "code": "taiwanese"],
                  ["name" : "Tapas Bars", "code": "tapas"],
                  ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                  ["name" : "Tex-Mex", "code": "tex-mex"],
                  ["name" : "Thai", "code": "thai"],
                  ["name" : "Traditional Norwegian", "code": "norwegian"],
                  ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                  ["name" : "Trattorie", "code": "trattorie"],
                  ["name" : "Turkish", "code": "turkish"],
                  ["name" : "Ukrainian", "code": "ukrainian"],
                  ["name" : "Uzbek", "code": "uzbek"],
                  ["name" : "Vegan", "code": "vegan"],
                  ["name" : "Vegetarian", "code": "vegetarian"],
                  ["name" : "Venison", "code": "venison"],
                  ["name" : "Vietnamese", "code": "vietnamese"],
                  ["name" : "Wok", "code": "wok"],
                  ["name" : "Wraps", "code": "wraps"],
                  ["name" : "Yugoslav", "code": "yugoslav"]]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
