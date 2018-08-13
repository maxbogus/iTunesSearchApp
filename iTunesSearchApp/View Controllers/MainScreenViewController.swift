//
//  ViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 26/07/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import UIKit
import CoreData

class MainScreenViewController: UITabBarController {
    @IBAction func clearResults(_ sender: Any) {
    }
    
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<SearchOption>!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }

}
