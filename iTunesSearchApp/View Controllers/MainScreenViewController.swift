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
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<SearchOption>!
    
    override func viewDidLoad() {
        dataController = AppDelegate.sharedInstance.dataController
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }

}
