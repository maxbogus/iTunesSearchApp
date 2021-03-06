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
    @IBOutlet var termInput: UITextField!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    let minValue = 0
    let maxValue = 200
    var country: String = "US"
    var countryIndex : IndexPath!
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<SearchOption>!

    let listOfCountries = ["GB": "United Kingdom", "RU": "Russian Federation", "US": "United States of America"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataController = AppDelegate.sharedInstance.dataController
        setupView(status: true)
        setupSearchOptions()
        subscribeToKeyboardNotifications()
        setUpFetchedResultsController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        limitResults.delegate = self
        termInput.delegate = self
        limitResults.addDoneButtonToKeyboard(myAction:  #selector(self.limitResults.resignFirstResponder))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        fetchedResultsController = nil
    }
    
    fileprivate func setupSearchOptions() {
        if let option: SearchOption = AppDelegate.sharedInstance.option {
            limitResults.text = String(option.limit)
            termInput.text = option.term
            explicitOption.isOn = option.explicity
            let indexPath = IndexPath(row:Int(option.countryIndex), section: 0)
            countryList.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        } else {
            limitResults.text = "1"
        }
    }
    
    fileprivate func setupView(status: Bool) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = status
            self.clearButton.alpha = (status) ? 1.0 : 0.5
            self.clearButton.isEnabled = status
            self.searchButton.alpha = (status) ? 1.0 : 0.5
            self.searchButton.isEnabled = status
        }
    }
    
    fileprivate func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
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
    
    @IBAction func clearAction(_ sender: Any) {
        explicitOption.isOn = false
        limitResults.text = nil
        termInput.text = nil
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let limit: Int = (Int(limitResults.text!) != nil) ? Int(limitResults.text!)! : 25
        let term: String = (termInput.text != nil) ? termInput.text! : ""
        let country: String = (self.country != "") ? self.country : "US"
        let escapedString = term.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let explicitness = explicitOption.isOn
        setupView(status: false)

        iTunesClient.sharedInstance.searchByParams(term: escapedString!, limit: limit, country: country, explicitness: explicitness) { (completed, results, resultsCount, error) in
            if completed {
                if let results = results, let count = resultsCount {
                    let row = (self.countryIndex != nil) ? self.countryIndex.row : 0
                    self.saveSearch(limit: limit, country: country, term: escapedString!, explicitness: explicitness, row: row)
                    let convertedLimit = Int16(limit)
                    self.saveResults(results: results, count: count, term: term, limit: convertedLimit, country: country, explicitness: explicitness)
                }
                self.setupView(status: true)
            } else {
                if let error = error {
                    self.showError(message: error)
                }
                self.setupView(status: true)
            }
        }
    }
    
    func saveSearch(limit: Int, country: String, term: String, explicitness: Bool, row: Int) {
        let searchOption = SearchOption(context: dataController.viewContext)
        searchOption.country = country
        searchOption.explicity = explicitness
        searchOption.limit = Int16(limit)
        searchOption.term = term
        searchOption.countryIndex = Int16(row)
        searchOption.creationDate = Date()
        dataController.saveContext()
    }
    
    func saveResults(results: Any, count: Int, term: String, limit: Int16, country: String, explicitness: Bool) {
        let results = iTunesResult.iTunesResultFromResults(results as! [[String : AnyObject]])
        let option = findOption(term: term, limit: limit, explicitness: explicitness, country: country)
        for result in results {
            let searchResult = SearchResult(context: dataController.viewContext)
            if let artistId = result.artistId, let collectionExplicitness = result.collectionExplicitness, let collectionPrice = result.collectionPrice, let discNumber = result.discNumber, let collectionId = result.collectionId, let discCount = result.discCount, let trackCount = result.trackCount, let trackExplicitness = result.trackExplicitness, let trackId = result.trackId, let trackPrice = result.trackPrice, let trackTimeMillis = result.trackTimeMillis, let trackNumber = result.trackNumber {
                searchResult.artistId = artistId
                searchResult.collectionExplicitness = collectionExplicitness
                searchResult.collectionPrice = collectionPrice
                searchResult.discNumber = discNumber
                searchResult.collectionId = collectionId
                searchResult.discCount = discCount
                searchResult.trackCount = trackCount
                searchResult.trackExplicitness = trackExplicitness
                searchResult.trackId = trackId
                searchResult.trackPrice = trackPrice
                searchResult.trackTimeMillis = trackTimeMillis
                searchResult.trackNumber = trackNumber
            }
            searchResult.artistName = result.artistName
            searchResult.artistViewUrl = result.artistViewUrl
            searchResult.artworkUrl100 = result.artworkUrl100
            searchResult.artworkUrl60 = result.artworkUrl60
            searchResult.collectionCensoredName = result.collectionCensoredName
            searchResult.collectionName = result.collectionName
            searchResult.collectionViewUrl = result.collectionViewUrl
            searchResult.country = result.country
            searchResult.creationDate = Date()
            searchResult.currency = result.currency
            searchResult.kind = result.kind
            searchResult.previewUrl = result.previewUrl
            searchResult.primaryGenreName = result.primaryGenreName
            searchResult.searchOption = option
            searchResult.trackCensoredName = result.trackCensoredName
            searchResult.trackName = result.trackName
            searchResult.trackViewUrl = result.trackViewUrl
            searchResult.wrapperType = result.wrapperType
            dataController.saveContext()
        }
        DispatchQueue.main.async {
            AppDelegate.sharedInstance.option = option
            let navigationController = (AppDelegate.sharedInstance.window?.rootViewController as? UINavigationController)!
            let tabBarController = navigationController.topViewController as! UITabBarController
            
            tabBarController.selectedIndex = 2
        }
    }
    
    private func findOption(term: String, limit: Int16, explicitness: Bool, country: String) -> SearchOption? {
        let predicate = NSPredicate(format: "term == %@ AND limit == %i AND country == %@", term, limit, country)
        var searchOption: SearchOption?
        do {
            try searchOption = fetchSearchOption(predicate)
        } catch {
            print("\(#function) error:\(error)")
        }
        return searchOption
    }
    
    private func fetchSearchOption(_ predicate: NSPredicate, sorting: NSSortDescriptor? = nil) throws -> SearchOption? {
        let fr: NSFetchRequest<SearchOption> = SearchOption.fetchRequest()
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let searchOption = try? dataController.viewContext.fetch(fr).first else {
            return nil
        }
        return searchOption
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
        self.countryIndex = indexPath
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
