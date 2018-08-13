//
//  PreviousResultsViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PreviousResultsViewController: UITableViewController, UITextFieldDelegate {
    var previousResults: [String: Any] = [:]
    var recievedData: [String: Any] = [:]
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<SearchOption>!
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<SearchOption> = SearchOption.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "searchOptions")
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch couldn't be performed \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        setUpFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
            print("dispatch")
            self.previousResults = self.recievedData
            self.tableView.reloadData()

            if (self.previousResults.count == 0) {
                let alert = UIAlertController(title: "Message", message: "No previous results", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        };
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of section rows")
        print(self.previousResults.count)
        return self.previousResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousSearchRequest", for: indexPath)
        let row = indexPath.row
        let indexes = Array(previousResults.keys)
        let key = indexes[row]
        
        cell.textLabel?.text = key
        print(key)
        let item = previousResults[key] as! [String: Any]
        cell.detailTextLabel?.text = item.description
        print(item.description)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example

        let currentCell = tableView.cellForRow(at: indexPath!)
        print((currentCell?.textLabel?.text)!)
        print((currentCell?.detailTextLabel?.text)!)
//        self.country = (currentCell?.textLabel?.text)!
    }
}

