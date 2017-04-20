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
    
    var searchText: String?
    var arrRes = [[String:AnyObject]]()
    var checked = [Bool]()
    var selectedIndexArray = [Int]()
    var result = JSON(parseJSON: "hi")
    // var yelpClient = YelpClient
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        request(location: searchText!)
        selectedIndexArray = [Int]()
        // yelpClient.request(location: searchText!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggested", for: indexPath) as! SuggestionTableViewCell
        var dict = self.arrRes[indexPath.row]
        cell.name.text = dict["name"] as? String
//        if checked[indexPath.row] == false {
//            cell.accessoryType = UITableViewCellAccessoryType.none
//        } else if checked[indexPath.row] == true {
//            cell.accessoryType = UITableViewCellAccessoryType.checkmark
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checked = [Bool](repeating: false, count: arrRes.count)
        return self.arrRes.count
    }
    
    
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggested", for: indexPath) as! SuggestionTableViewCell
        var dict = self.arrRes[indexPath.row]
        cell.name.text = dict["name"] as? String
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        selectedIndexArray.append(indexPath.row)
//        if checked[indexPath.row] == false{
//            cell.accessoryType = UITableViewCellAccessoryType.checkmark
//            checked[indexPath.row] = true
//            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//            selectedIndexArray.append(indexPath.row)
//        }
//        else if checked[indexPath.row] == true{
//            cell.accessoryType = UITableViewCellAccessoryType.none
//            checked[indexPath.row] = false
//        }
    
    }
    
    
    @IBAction func generatePlan(_ sender: Any) {
        var categories = [Any]()
        var addresses = [String]()
        var names = [String]()
        let day_index = getDayIndex()
        print(selectedIndexArray)
        for index in selectedIndexArray {
            var dict = self.result[index]
            names.append(dict["name"].stringValue)
            let catDict = dict["categories"].arrayValue.map({$0["alias"].stringValue})
            categories.append(catDict)
            let addarray = dict["location"]["display_address"].arrayObject as! [String]?
            addresses.append((addarray?.joined(separator: ", "))!)
        }
        
        print("ADDRESSES!!!! ! ! ! ! ! !")
        print(addresses)
        
        getOptimalRoute(addresses: addresses, categories: categories, names: names, day_index: day_index)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getDayIndex() -> Int{
        let dict = ["Sunday": 0, "Monday":1, "Tuesday":2, "Wednesday":3, "Thursday": 4, "Friday": 5, "Saturday":6]
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: date)
        return dict[dayInWeek]!
        
    }
    
    func request(location: String) {
        let url = "https://api.yelp.com/v3/businesses/search"
        let header: HTTPHeaders = ["Authorization": "Bearer o-sJv-BY1vtPdkbnCDTVyVdX8yxvhdCvvTv--CEPcg_z2Otmaa7qko-vvBOsZ-8AaPjYc6CkArgOWMT180zycCb60u51pjw4gyiYAZCDpq7AXSUf_uqinsajklzUWHYx"]
        let parameters2 = [
            "term": "tourist attractions",
            "location": location,
            "limit" : 50,
            "sort_by":"review_count"
            ] as [String : Any]
        var rest_results = [[String:AnyObject]]()
        
        Alamofire.request(url, parameters: parameters2, headers: header).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let json = JSON(responseData.result.value!)
                if let resData = json["businesses"].arrayObject {
                    self.result = JSON(responseData.result.value!)["businesses"]
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    self.tableView.reloadData()
                }
                //                print(i['name'] + "," + i['categories'])
                //                print(i['location']['display_address'])
                //                name, categories, display address
            }
        }
   
    let parameters3 = [
        "term": "restaurants",
        "location": location,
        "limit" : 50,
        "sort_by":"review_count"
        ] as [String : Any]
    
        Alamofire.request(url, parameters: parameters3, headers: header).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let json = JSON(responseData.result.value!)
                if let resData = json["businesses"].arrayObject {
                    self.result = JSON(responseData.result.value!)["businesses"]
                    rest_results = resData as! [[String:AnyObject]]
                    for val in rest_results{
                        self.arrRes.append(val)
                    }
                }
                if rest_results.count > 0 {
                    self.tableView.reloadData()
                }
                //                print(i['name'] + "," + i['categories'])
                //                print(i['location']['display_address'])
                //                name, categories, display address
            }
        }
    
    

    let parameters4 = [
        "term": "bars",
        "location": location,
        "limit" : 50,
        "sort_by":"review_count"
        ] as [String : Any]
        
        Alamofire.request(url, parameters: parameters4, headers: header).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let json = JSON(responseData.result.value!)
                if let resData = json["businesses"].arrayObject {
                    self.result = JSON(responseData.result.value!)["businesses"]
                    rest_results = resData as! [[String:AnyObject]]
                    for val in rest_results{
                        self.arrRes.append(val)
                    }
                }
                if rest_results.count > 0 {
                    self.tableView.reloadData()
                }
                //                print(i['name'] + "," + i['categories'])
                //                print(i['location']['display_address'])
                //                name, categories, display address
            }
        }
        
        
    }

    

    func getOptimalRoute(addresses: [Any], categories: [Any], names: [String], day_index: Int){
        let url = "http://itravel.pythonanywhere.com/getOptimalRoute"
        //
        //        let header: HTTPHeaders = ["Authorization": "Bearer o-sJv-BY1vtPdkbnCDTVyVdX8yxvhdCvvTv--CEPcg_z2Otmaa7qko-vvBOsZ-8AaPjYc6CkArgOWMT180zycCb60u51pjw4gyiYAZCDpq7AXSUf_uqinsajklzUWHYx"]
        
        let stringaddr = addresses.description
        let stringcateg = categories.description
        
        let parameters3 = ["addresses": stringaddr,
                           "categories": stringcateg,
            "names": names.description,
            "day_index": day_index.description,
        ] as [String : Any]
        
//        print(addresses)
//        print(categories)
//        print(names)
        
        Alamofire.request(url, parameters: parameters3).responseString { response in
            print("RESPONSE REQUEST")
            print(response.request)  // original URL request
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
