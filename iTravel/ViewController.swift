//
//  ViewController.swift
//  iTravel
//
//  Created by Aakash Bhalothia on 3/25/17.
//  Copyright © 2017 Aakash Bhalothia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let x = YelpClient()
//        x.request()
        x.requesttomudit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

