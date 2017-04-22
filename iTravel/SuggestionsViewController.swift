//
//  SuggestionsViewController.swift
//  iTravel
//
//  Created by Aakash Bhalothia on 4/1/17.
//  Copyright © 2017 Aakash Bhalothia. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON


class SuggestionsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var city: String?
    var yelpResults = [[String:AnyObject]]()
    
    
    
    var namesOfSelectedLocations = Set<String>()
    var isDriving: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        sendYELPRequest(city: city!) // sends request to YELP. Method down below.
        selectedIndexArray = [Int]() // Stores the indices selected from the YELP table created.
        namesOfSelectedLocations = Set<String>()
        

    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        selectedIndexArray = [Int]()
        namesOfSelectedLocations = Set<String>()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addToSelectedIndexArray(index: Int) {
        selectedIndexArray.append(index)
    }
    
    func removeFromSelectedIndexArray(index: Int) {
        selectedIndexArray.remove(at: selectedIndexArray.index(of: index)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggested", for: indexPath) as! SuggestionTableViewCell
        var location = self.yelpResults[indexPath.row]
        cell.name.text = location["name"] as? String
        
        let row_number = indexPath.row
        // The following snippet is some delegate stuff that I don't fully understand
        // It is basically doing the below when the switch 
        cell.tapAction = { (cell) in
            if selectedIndexArray.contains(row_number) {
                self.removeFromSelectedIndexArray(index: row_number)
            } else {
                self.addToSelectedIndexArray(index: row_number)
            }
        }
        
        
        if (selectedIndexArray.contains(indexPath.row)) {
            cell.paperSwitch.setOn(true, animated: true)
        } else {
            cell.paperSwitch.setOn(false, animated: false)
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.yelpResults.count
    }
    
    
    
    
    
    // This method is called when the generate button is clicked on.
    @IBAction func generatePlan(_ sender: Any) {
        var categories = [[String]]() // Categories of the locations to send to python script. Should be an Array of array of strings
        var addresses = [String]() // Addresses to send to python script.
        var names = [String]() // Names of locations as selected on the table view.
        let day_index = getDayIndex() // Current day. 0-Sunday, 6-Saturday
        print("Printing the selected index array: ")
        print(selectedIndexArray)
        for index in selectedIndexArray {
            let yelpLocationObject = self.yelpResults[index]
            var yelpLocationObjectAsJSON = JSON(yelpLocationObject)
            names.append((yelpLocationObjectAsJSON["name"].stringValue)) // Add the name of the YELP object
            let categoryList = yelpLocationObjectAsJSON["categories"].arrayValue.map({$0["alias"].stringValue}) // TODO: Check things here on.
            categories.append(categoryList)
            let addressList = yelpLocationObjectAsJSON["location"]["display_address"].arrayObject as! [String]?
            addresses.append((addressList?.joined(separator: ", "))!)
        }
        
        print("Printing addresses of the locations that user selected: ")
        print(addresses)
        
        getOptimalRoute(addresses: addresses, categories: categories, names: names, day_index: day_index) // Calls python script
    }

    // Returns day index to send to python script.
    func getDayIndex() -> Int{
        let dict = ["Sunday": 0, "Monday":1, "Tuesday":2, "Wednesday":3, "Thursday": 4, "Friday": 5, "Saturday":6]
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: date)
        return dict[dayInWeek]!
        
    }
    
    
    func getYELPParameterWithTerm(terms: [String], city: String) -> [[String:Any]] {
        // takes in a list of terms to create parameters for
        // returns a list of parameter dictionaries
        
        var parameters_list: [[String:Any]] = []
        
        for term in terms {
            parameters_list.append([
                "term": term,
                "location": city,
                "limit" : 50,
                "sort_by":"review_count"
            ])
        }
        return parameters_list
    }
    
    func sendYELPRequest(city: String) {
        let url = "https://api.yelp.com/v3/businesses/search"
        let header: HTTPHeaders = ["Authorization": "Bearer o-sJv-BY1vtPdkbnCDTVyVdX8yxvhdCvvTv--CEPcg_z2Otmaa7qko-vvBOsZ-8AaPjYc6CkArgOWMT180zycCb60u51pjw4gyiYAZCDpq7AXSUf_uqinsajklzUWHYx"]
        
        
        let terms = ["tourist_attractions", "restaurants", "bars"]
        
        let parameters_list = getYELPParameterWithTerm(terms: terms, city: city)
        
        
        for parameter in parameters_list {
            Alamofire.request(url, parameters: parameter, headers: header).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let json = JSON(responseData.result.value!)
                    if let listOfBusinesses = json["businesses"].arrayObject {
                        
                        let second_results = listOfBusinesses as! [[String:AnyObject]]
                        self.yelpResults.append(contentsOf: second_results)
                    }
                    if self.yelpResults.count > 0 {
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
        }
    }

    

    func getOptimalRoute(addresses: [String], categories: [[String]], names: [String], day_index: Int){
        let url = "http://itravel.pythonanywhere.com/getOptimalRoute"

        
        let addressesAsString = addresses.description
        let categoriesAsString = categories.description
        
        let parameters = ["addresses": addressesAsString,
                           "categories": categoriesAsString,
            "names": names.description,
            "day_index": day_index.description,
            "is_driving": isDriving
        ] as [String : Any]
        
        
        Alamofire.request(url, parameters: parameters).responseString { response in
//            print("RESPONSE REQUEST")
//            print(response.request)  // original URL request
            print("RESPONSE RESPONSE!")
            print(response.response) // HTTP URL response
            print("RESPONSE DATA!")
            print(response.data)     // server data
            print("RESPONSE RESULT!")
            print(response.result)   // result of response serialization
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }

}
