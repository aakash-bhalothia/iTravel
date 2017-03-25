//
//  yelpRequests.swift
//  iTravel
//
//  Created by Aakash Bhalothia on 3/25/17.
//  Copyright © 2017 Aakash Bhalothia. All rights reserved.
//

import Foundation
import Alamofire


class YelpClient {
 
    func request(){
    let url = "https://api.yelp.com/v3/autocomplete"
        
        let header: HTTPHeaders = ["Authorization": "Bearer o-sJv-BY1vtPdkbnCDTVyVdX8yxvhdCvvTv--CEPcg_z2Otmaa7qko-vvBOsZ-8AaPjYc6CkArgOWMT180zycCb60u51pjw4gyiYAZCDpq7AXSUf_uqinsajklzUWHYx"]
        let parameters2 = ["text": "del",
                          "latitude": "37.786882",
                          "longitude": "-122.399972",
        ]
        
        Alamofire.request(url, parameters: parameters2, headers: header).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    func requesttomudit(){
        let url = "https://mudit2103.pythonanywhere.com/thing"
//        
//        let header: HTTPHeaders = ["Authorization": "Bearer o-sJv-BY1vtPdkbnCDTVyVdX8yxvhdCvvTv--CEPcg_z2Otmaa7qko-vvBOsZ-8AaPjYc6CkArgOWMT180zycCb60u51pjw4gyiYAZCDpq7AXSUf_uqinsajklzUWHYx"]
        let parameters2 = ["x": "25",
                           
                        
                           ]
        
        Alamofire.request(url, parameters: parameters2).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }

    
}
