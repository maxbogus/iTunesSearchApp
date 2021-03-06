//
//  AppDelegate.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 26/07/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController.shared
    var option: SearchOption!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.sharedInstance = self
        dataController.load()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        saveViewContext()
    }

    func saveViewContext() {
        try? dataController.viewContext.save()
    }

    static var sharedInstance = AppDelegate()
}

