//
//  SearchResultsViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var results: Array<Any>!
    @IBOutlet var photoViewCollection: UICollectionView!
    var searchOption: SearchOption!
    var dataController: DataController!
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    var fetchedResultsController:NSFetchedResultsController<SearchResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataController = AppDelegate.sharedInstance.dataController
        searchOption = AppDelegate.sharedInstance.option
        if searchOption != nil {
            setUpFetchedResultsController()
        }

        if (self.results == nil || self.results.count == 0) {
            let alert = UIAlertController(title: "Message", message: "No results", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    fileprivate func setUpFetchedResultsController() {
        print(searchOption)
        let fetchRequest:NSFetchRequest<SearchResult> = SearchResult.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let predicate = NSPredicate(format: "searchOption == %@", searchOption)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "searchResults")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch couldn't be performed \(error.localizedDescription)")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if fetchedResultsController == nil {
            return 1
        }
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchedResultsController == nil {
            return 1
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultItem", for: indexPath) as! SearchResultsViewCellController
        cell.image?.image = nil
        //        cell.activityIndicator.startAnimating()
        if fetchedResultsController != nil {
            let photo = fetchedResultsController.object(at: indexPath)
        }
        
        //        setUpImage(using: cell, photo: photo, collectionView: collectionView, index: indexPath)
        
        return cell
    }
    
}

extension SearchResultsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
            break
        case .delete:
            deletedIndexPaths.append(indexPath!)
            break
        case .update:
            updatedIndexPaths.append(indexPath!)
            break
        case .move:
            print("Move an item. We don't expect to see this in this app.")
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        photoViewCollection.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.photoViewCollection.insertItems(at: [indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.photoViewCollection.deleteItems(at: [indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.photoViewCollection.reloadItems(at: [indexPath])
            }
            
        }, completion: nil)
    }
    
}
