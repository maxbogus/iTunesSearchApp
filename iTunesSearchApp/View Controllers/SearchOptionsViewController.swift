//
//  SearchOptionsViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit

class SearchOptionsViewController: UIViewController {
    @IBOutlet var countryList: UITableView!
    @IBOutlet var explicitOption: UISwitch!
    @IBOutlet var limitResults: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    @IBAction func searchAction(_ sender: Any) {
        iTunesClient.sharedInstance.searchByParams(term: "john", limit: 25) { (completed, results, resultsCount, error) in
            if completed {
                if let results = results, let count = resultsCount {
                    print(results)
                    print(count)
                }
            } else {
                print(error as Any)
            }
        }
    }
}

