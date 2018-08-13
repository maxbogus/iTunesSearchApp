//
//  SearchOptionsViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchOptionsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var countryList: UITableView!
    @IBOutlet var explicitOption: UISwitch!
    @IBOutlet var limitResults: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var termInput: UITextField!
    
    let minValue = 0
    let maxValue = 200
    var country: String = "US"
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<SearchOption>!

    let listOfCountries = ["GA": "Gabon", "RU": "Russian Federation", "US": "United States of America"]
    
    @IBAction func searchAction(_ sender: Any) {
        let limit: Int = (Int(limitResults.text!) != nil) ? Int(limitResults.text!)! : 25
        let term: String = (termInput.text != nil) ? termInput.text! : ""
        let country: String = (self.country != "") ? self.country : "US"
        let escapedString = term.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let explicitness = explicitOption.isOn

        iTunesClient.sharedInstance.searchByParams(term: escapedString!, limit: limit, country: country, explicitness: explicitness) { (completed, results, resultsCount, error) in
            if completed {
                if let results = results, let count = resultsCount {
                    let search: [String : Any] = ["limit": limit,
                                                  "country": country,
                                                  "term": escapedString as! String,
                                                  "explicitness": explicitness]
                    self.saveResults(results: results, count: count)
                    self.saveSearch(result: search)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func saveSearch(result: [String: Any]) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)

        DispatchQueue.main.async {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "PreviousResultsController") as! PreviousResultsViewController
            var tempResults = controller.previousResults
            tempResults[dateString] = result
            print("temp")
            print(tempResults)
            controller.recievedData = tempResults
            print("controller")
            print(controller.recievedData)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let tabBarController = appDelegate.window!.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
        }
    }
    
    func saveResults(results: Any, count: Int) {
//        print("save results")
//        print(results)
//        print(count)
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "SearchResultsController") as! SearchResultsViewController
//            controller.location = location
            
            if let tabBarController = appDelegate.window!.rootViewController as? UITabBarController {
//                print(1)
//                tabBarController.selectedIndex = 2
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        limitResults.delegate = self
        termInput.delegate = self
        
        limitResults.addDoneButtonToKeyboard(myAction:  #selector(self.limitResults.resignFirstResponder))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }

    @IBAction func clearAction(_ sender: Any) {
        explicitOption.isOn = false
        limitResults.text = nil
        termInput.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.limitResults {
            let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            if newText.isEmpty {
                return true
            }
            else if let intValue = Int(newText), intValue >= self.minValue , intValue <= self.maxValue {
                return true
            }
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        let row = indexPath.row
        let indexes = Array(listOfCountries.keys)
        let key = indexes[row]
        
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = listOfCountries[key]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!)
        self.country = (currentCell?.textLabel?.text)!
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if limitResults.isFirstResponder {
            view.frame.origin.y -= self.getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if limitResults.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
