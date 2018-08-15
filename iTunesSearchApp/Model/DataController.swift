//
//  DataController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 29/07/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistantContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistantContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName:String) {
        persistantContainer = NSPersistentContainer(name: modelName)
        
        backgroundContext = persistantContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistantContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
    
}

extension DataController {
    
    func autoSaveViewContext (interval:TimeInterval = 15) {
        print("autosaving...")
        guard interval > 0 else {
            print("cannot use negative numbers")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}

extension DataController {
    func fetchOptions() throws -> [SearchOption]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchOption")
        
        guard let option = try viewContext.fetch(fr) as? [SearchOption] else {
            return nil
        }
        return option
    }
    
    func fetchResults() throws -> [SearchResult]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchOption")
        
        guard let results = try viewContext.fetch(fr) as? [SearchResult] else {
            return nil
        }
        return results
    }
}
