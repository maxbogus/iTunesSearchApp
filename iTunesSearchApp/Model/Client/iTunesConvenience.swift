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
    func searchByParams(term: String, limit: Int, completionHandlerForSession: @escaping (_ success: Bool, _ resultsDictionary: [[String:AnyObject]]?, _ totalPages: Int?, _ errorString: String?) -> Void) {
        let methodParameters = [
            iTunesParameterKeys.Term: term as Any,
            iTunesParameterKeys.Lang: iTunesParameterValues.Lang,
            iTunesParameterKeys.Limit: limit as Any,
            ]
        let _ = taskForGETMethod("search", parameters: methodParameters as [String : AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if error != nil {
                completionHandlerForSession(false, nil, nil, "Search failed.")
            } else {
                if let responseDictionary = results as? NSDictionary {
                    if let resultsDictionary = responseDictionary[iTunesResponseKeys.Results] as? [[String:AnyObject]], let totalPages = responseDictionary[iTunesResponseKeys.ResultsCount] as? Int {
                        completionHandlerForSession(true, resultsDictionary, totalPages, nil)
                    } else {
                        print("Could not find \(iTunesResponseKeys.Results) in \(responseDictionary)")
                        completionHandlerForSession(false, nil, nil, "Get results dictionary failed.")
                    }
                } else {
                    print("Couldn't find response: \(results!)")
                    completionHandlerForSession(false, nil, nil, "Get response failed.")
                }
            }
        }
    }
    
    // MARK: Lookup by params (GET) Methods
    func lookupByParams(term: String, limit: Int, completionHandlerForSession: @escaping (_ success: Bool, _ resultsDictionary: NSDictionary?, _ totalPages: Int?, _ errorString: String?) -> Void) {
        let methodParameters = [
            iTunesParameterKeys.Term: term as Any,
            iTunesParameterKeys.Lang: iTunesParameterValues.Lang,
            iTunesParameterKeys.Limit: limit as Any,
            ]
        let _ = taskForGETMethod("lookup", parameters: methodParameters as [String : AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if error != nil {
                completionHandlerForSession(false, nil, nil, "Search failed.")
            } else {
                if let resultsDictionary = results?[iTunesResponseKeys.Results] as? NSDictionary, let totalPages = results?[iTunesResponseKeys.ResultsCount] as? Int {
                    completionHandlerForSession(true, resultsDictionary, totalPages, nil)
                } else {
                    print("Could not find \(iTunesResponseKeys.Results) in \(results!)")
                    completionHandlerForSession(false, nil, nil, "Get results dictionary failed.")
                }
            }
        }
    }

}
