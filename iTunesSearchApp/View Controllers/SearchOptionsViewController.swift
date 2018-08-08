//
//  SearchOptionsViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit

class SearchOptionsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var countryList: UITableView!
    @IBOutlet var explicitOption: UISwitch!
    @IBOutlet var limitResults: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var termInput: UITextField!
    
    @IBAction func searchAction(_ sender: Any) {
        let limit: Int = (Int(limitResults.text!) != nil) ? Int(limitResults.text!)! : 25
        let term: String = (termInput.text != nil) ? termInput.text! : ""

        iTunesClient.sharedInstance.searchByParams(term: term, limit: limit, explicitness: explicitOption.isOn) { (completed, results, resultsCount, error) in
            if completed {
                if let results = results, let count = resultsCount {
                    print(results)
                    print(count)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
//        if termInput.isFirstResponder {
//            view.frame.origin.y -= self.getKeyboardHeight(notification)
//        }
        if limitResults.isFirstResponder {
            view.frame.origin.y -= self.getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
//        if termInput.isFirstResponder {
//            view.frame.origin.y = 0
//        }
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
