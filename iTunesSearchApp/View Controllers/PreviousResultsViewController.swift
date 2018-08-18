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
    var previousResults: [SearchOption]!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataController = AppDelegate.sharedInstance.dataController
        setUpFetchedResultsController()

        DispatchQueue.main.async {
            if let searchOptions = self.loadSearchOptions() {
                self.previousResults = searchOptions
                self.tableView.reloadData()
            } else {
                self.previousResults = nil
                self.tableView.reloadData()
            }

            if (self.previousResults == nil || self.previousResults.count == 0) {
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
    
    func loadSearchOptions() -> [SearchOption]? {
        if let controller = fetchedResultsController {
            if let objects = controller.fetchedObjects {
                return objects as [SearchOption]
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[0].objects!.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousSearchRequest", for: indexPath)
        
        if self.validateIndexPath(indexPath) {
            let item = fetchedResultsController.object(at: indexPath)
            let term: String = (item.term != nil && item.term != "") ? item.term! : "no term"
            let country: String = (item.country != nil) ? item.country! : "no country"
            let limit: String = String(item.limit)
            let explicity: String = (item.explicity) ? "Yes" : "No"
            let text: String = (item.creationDate?.description)!

            cell.detailTextLabel?.text = "Term: \(term). Coutry: \(country). Limit: \(limit). Explicity: \(explicity)"
            cell.textLabel?.text = text
        } else {
            print("Attempting to configure a cell for an indexPath that is out of bounds: \(indexPath)")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        if self.validateIndexPath(indexPath!) {
            AppDelegate.sharedInstance.option = fetchedResultsController.object(at: indexPath!)
        } else {
            print("Attempting to configure a cell for an indexPath that is out of bounds: \(String(describing: indexPath))")
        }

        let navigationController = (AppDelegate.sharedInstance.window?.rootViewController as? UINavigationController)!
        let tabBarController = navigationController.topViewController as! UITabBarController
        
        tabBarController.selectedIndex = 0

    }
    
    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.fetchedResultsController?.sections,
            indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }
}

