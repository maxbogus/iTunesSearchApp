//
//  PreviousResultsViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit

class PreviousResultsViewController: UITableViewController, UITextFieldDelegate {
    var previousResults: [String: Any] = [
        "2018-08-12 03:12:12": ["explicitness": true, "limit": 2, "term": "term", "country": "US"],
        "2018-08-12 03:12:13": ["explicitness": true, "limit": 2, "term": "term", "country": "US"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (previousResults == nil || previousResults.count == 0) {
            let alert = UIAlertController(title: "Message", message: "No previous results", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.previousResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousSearchRequest", for: indexPath)
        let row = indexPath.row
        let indexes = Array(previousResults.keys)
        let key = indexes[row]
        
        cell.textLabel?.text = key
//        cell.detailTextLabel?.text = previousResults[key]
        cell.detailTextLabel?.text = "previousResults[key]"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
//
//        let currentCell = tableView.cellForRow(at: indexPath!)
//        self.country = (currentCell?.textLabel?.text)!
//    }
}

