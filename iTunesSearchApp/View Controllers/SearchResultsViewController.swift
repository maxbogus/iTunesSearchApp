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
    @IBOutlet var searchResultsCollection: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!

    var results: Array<Any>!
    var searchOption: SearchOption!
    var dataController: DataController!
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    var fetchedResultsController:NSFetchedResultsController<SearchResult>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataController = AppDelegate.sharedInstance.dataController
        searchOption = AppDelegate.sharedInstance.option

        if searchOption != nil {
            setUpFetchedResultsController()
        }

        searchResultsCollection.delegate = self
        searchResultsCollection.dataSource = self

        if (searchOption != nil) {
            if let results = searchOption.results, results.count == 0 {
                self.showError(error: "No results")
            }
        } else {
            self.showError(error: "No results")
        }
        
        searchResultsCollection?.reloadData()
    }
    
    override func viewDidLoad() {
        updateFlowLayout(view.frame.size)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateFlowLayout(size)
    }
    
    fileprivate func setUpFetchedResultsController() {
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
    
    private func showError(error: String) {
        let alert = UIAlertController(title: "Message", message: "\(error)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateFlowLayout(_ withSize: CGSize) {
        
        let landscape = withSize.width > withSize.height
        
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        
        let dimension = (withSize.width - ((items + 1) * space)) / items
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if fetchedResultsController == nil {
            return 0
        }
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchedResultsController == nil {
            return 0
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultItem", for: indexPath) as! SearchResultsViewCellController

        cell.activityIndicator.startAnimating()
        if fetchedResultsController != nil {
            let result: SearchResult = fetchedResultsController.object(at: indexPath)
            cell.image?.image = nil
            var trackName: String = ""; var artistName: String = ""
            if let track: String = result.trackName {
                trackName = track
            }
            if let artist: String = result.artistName {
                artistName = artist
            }
            
            cell.descriptionLabel.text = "\(artistName) \(trackName)"
            
        } else {
            cell.image?.image = nil
            cell.descriptionLabel.text = "no text"
        }
        cell.activityIndicator.stopAnimating()
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultToOpen = fetchedResultsController.object(at: indexPath)

        let songInfoViewController = self.storyboard!.instantiateViewController(withIdentifier: "SongInfoController") as! SongInfoViewController
        songInfoViewController.dataController = dataController
        songInfoViewController.result = resultToOpen
        self.navigationController!.pushViewController(songInfoViewController, animated: true)
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
        
        searchResultsCollection.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.searchResultsCollection.insertItems(at: [indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.searchResultsCollection.deleteItems(at: [indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.searchResultsCollection.reloadItems(at: [indexPath])
            }
            
        }, completion: nil)
    }
    
}
