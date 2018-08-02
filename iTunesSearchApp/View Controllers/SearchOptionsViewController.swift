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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

