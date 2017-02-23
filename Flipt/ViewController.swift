//
//  ViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 1/16/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let store = BookDataStore.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FliptAPIClient.getUserProfile { (dict) in
            print(dict)
        }
    }

}
