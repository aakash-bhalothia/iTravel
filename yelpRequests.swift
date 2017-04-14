////
////  yelpRequests.swift
////  iTravel
////
////  Created by Aakash Bhalothia on 3/25/17.
////  Copyright © 2017 Aakash Bhalothia. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import SwiftyJSON
//
//
//class YelpClient {
//    
//    var arrayLocations: [[String:AnyObject]]
//    let request: String
//    
//    init(search: String) {
//        self.request = search
//        self.arrayLocations = [[String:AnyObject]]()
//    }
//    
//    func request(location: String) -> [[String:AnyObject]]{
//    let url = "https://api.yelp.com/v3/businesses/search"
//        let header: HTTPHeaders = ["Authorization": "Bearer o-sJv-BY1vtPdkbnCDTVyVdX8yxvhdCvvTv--CEPcg_z2Otmaa7qko-vvBOsZ-8AaPjYc6CkArgOWMT180zycCb60u51pjw4gyiYAZCDpq7AXSUf_uqinsajklzUWHYx"]
//        let parameters2 = [
//                          "term": "tourist attractions",
//                          "location": location,
//                          "limit" : 50,
//                          "sort_by":"review_count"
//        ] as [String : Any]
//        
//        Alamofire.request(url, parameters: parameters2, headers: header).responseJSON { (responseData) -> Void in
//            if((responseData.result.value) != nil) {
//                let json = JSON(responseData.result.value!)
//                //print(json["businesses"])
//                if let resData = json["businesses"].arrayObject {
//                    print (resData)
//                    self.arrayLocations = resData as! [[String:AnyObject]]
//                }
////                print(i['name'] + "," + i['categories'])
////                print(i['location']['display_address'])
////                name, categories, display address
//            }
//        }
//        return self.arrayLocations
//    }
//    
////    func getOptimalRoute(){
////        let url = "https://itravel.pythonanywhere.com/getOptimalRoute"
//////        
//////        let header: HTTPHeaders = ["Authorization": "Bearer o-sJv-BY1vtPdkbnCDTVyVdX8yxvhdCvvTv--CEPcg_z2Otmaa7qko-vvBOsZ-8AaPjYc6CkArgOWMT180zycCb60u51pjw4gyiYAZCDpq7AXSUf_uqinsajklzUWHYx"]
////        let parameters2 = ["addresses": "25",
////                           "categories":
////                            "names":
////                            "day_index":
////                           ]
////        
////        Alamofire.request(url, parameters: parameters2).responseJSON { response in
////            print(response.request)  // original URL request
////            print(response.response) // HTTP URL response
////            print(response.data)     // server data
////            print(response.result)   // result of response serialization
////            if let JSON = response.result.value {
////                print("JSON: \(JSON)")
////            }
////        }
////    }
//
//    
//}
