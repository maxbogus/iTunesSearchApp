//
//  SearchResultsViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsViewController: UITableViewController {
    var results: Array<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.results == nil || self.results.count == 0) {
            let alert = UIAlertController(title: "Message", message: "No results", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

