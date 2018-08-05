//
//  iTunesConvenience.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 01/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import UIKit
import Foundation

// MARK: - iTunesClient (Convenient Resource Methods)

extension iTunesClient {
    
    // MARK: Search media by params (GET) Methods
    func searchByParams(latitude: Double, longitude: Double, pageNumber: Int, completionHandlerForSession: @escaping (_ success: Bool, _ photosArray: [[String: AnyObject]]?, _ totalPages: Int?, _ errorString: String?) -> Void) {
        let methodParameters = [
            iTunesParameterKeys.Lang: iTunesParameterValues.Lang,
            iTunesParameterKeys.Limit: iTunesParameterValues.Limit,
        ]
        let _ = taskForGETMethod(parameters: methodParameters as [String : AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if error != nil {
                completionHandlerForSession(false, nil, nil, "Search failed.")
            } else {
                if let photosDictionary = results?[iTunesResponseKeys.Photos] as? NSDictionary {
                    if let photosArray = photosDictionary[iTunesResponseKeys.Photo] as? [[String: AnyObject]], let totalPages = photosDictionary[iTunesResponseKeys.Pages] as? Int {
                        completionHandlerForSession(true, photosArray, totalPages, nil)
                    } else {
                        print("Could not find \(iTunesResponseKeys.Photo) in \(results!)")
                        completionHandlerForSession(false, nil, nil, "Get photo array failed.")
                    }
                } else {
                    print("Could not find \(iTunesResponseKeys.Photos) in \(results!)")
                    completionHandlerForSession(false, nil, nil, "Get photos dictionary failed.")
                }
            }
        }
    }
    
    // MARK: Lookup by params (GET) Methods
    func lookupByParams(latitude: Double, longitude: Double, pageNumber: Int, completionHandlerForSession: @escaping (_ success: Bool, _ photosArray: [[String: AnyObject]]?, _ totalPages: Int?, _ errorString: String?) -> Void) {
        let methodParameters = [
            iTunesParameterKeys.Lang: iTunesParameterValues.Lang,
            iTunesParameterKeys.Limit: iTunesParameterValues.Limit,
        ]
        let _ = taskForGETMethod(parameters: methodParameters as [String : AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if error != nil {
                completionHandlerForSession(false, nil, nil, "Search failed.")
            } else {
                if let photosDictionary = results?[iTunesResponseKeys.Photos] as? NSDictionary {
                    if let photosArray = photosDictionary[iTunesResponseKeys.Photo] as? [[String: AnyObject]], let totalPages = photosDictionary[iTunesResponseKeys.Pages] as? Int {
                        completionHandlerForSession(true, photosArray, totalPages, nil)
                    } else {
                        print("Could not find \(iTunesResponseKeys.Photo) in \(results!)")
                        completionHandlerForSession(false, nil, nil, "Get photo array failed.")
                    }
                } else {
                    print("Could not find \(iTunesResponseKeys.Photos) in \(results!)")
                    completionHandlerForSession(false, nil, nil, "Get photos dictionary failed.")
                }
            }
        }
    }

}
