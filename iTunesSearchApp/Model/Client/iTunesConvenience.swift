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
    
    // MARK: Search photos by coordinates (GET) Methods
    func searchByLatLon(latitude: Double, longitude: Double, pageNumber: Int, completionHandlerForSession: @escaping (_ success: Bool, _ photosArray: [[String: AnyObject]]?, _ totalPages: Int?, _ errorString: String?) -> Void) {
        let methodParameters = [
            iTunesParameterKeys.Method: iTunesParameterValues.SearchMethod,
            iTunesParameterKeys.APIKey: iTunesParameterValues.APIKey,
            iTunesParameterKeys.BoundingBox: bboxString(latitude: latitude, longitude: longitude),
            iTunesParameterKeys.SafeSearch: iTunesParameterValues.UseSafeSearch,
            iTunesParameterKeys.Extras: iTunesParameterValues.MediumURL,
            iTunesParameterKeys.Format: iTunesParameterValues.ResponseFormat,
            iTunesParameterKeys.NoJSONCallback: iTunesParameterValues.DisableJSONCallback,
            iTunesParameterKeys.Page: "\(pageNumber)",
            iTunesParameterKeys.PerPage: iTunesParameterValues.PerPageValue
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
    
    private func bboxString(latitude: Double, longitude: Double) -> String {
        // ensure bbox is bounded by minimum and maximums
        let minimumLon = max(longitude - Constants.SearchBBoxHalfWidth, Constants.SearchLonRange.0)
        let minimumLat = max(latitude - Constants.SearchBBoxHalfHeight, Constants.SearchLatRange.0)
        let maximumLon = min(longitude + Constants.SearchBBoxHalfWidth, Constants.SearchLonRange.1)
        let maximumLat = min(latitude + Constants.SearchBBoxHalfHeight, Constants.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
}
