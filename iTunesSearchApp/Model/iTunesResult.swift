//
//  iTunesResult.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 06/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

class iTunesResultsDataSource {
    var locations = [iTunesResult]()
    var currentStudentLocation: iTunesResult?
    
    // MARK: Shared Instance
    static var sharedInstance = iTunesResultsDataSource()
}

struct iTunesResult {
    
    // MARK: Properties
    
    let artistId: Int16?
    let artistName: String?
    let artistViewUrl: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionCensoredName: String?
    let collectionExplicitness: Bool?
    let collectionId: Int16?
    let collectionName: String?
    let collectionPrice: Double?
    let collectionViewUrl: String?
    let country: String?
    let currency: String?
    let discCount: Int16?
    let discNumber: Int16?
    let kind: String?
    let previewUrl: String?
    let trackCensoredName: String?
    let trackCount: Int16?
    let trackExplicitness: Bool?
    let trackId: Int16?
    let trackName: String?
    let trackNumber: Int16?
    let trackPrice: Double?
    let trackViewUrl: String?
    let trackTimeMillis: Int16?
    let primaryGenreName: String?
    let wrapperType: String?
    
    // MARK: Initializers
    
    // construct a iTunesResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        artistId = dictionary[iTunesClient.iTunesResponseKeys.ArtistId] as? Int16
        artistName = dictionary[iTunesClient.iTunesResponseKeys.ArtistName] as? String
        artistViewUrl = dictionary[iTunesClient.iTunesResponseKeys.ArtistViewUrl] as? String
        artworkUrl60 = dictionary[iTunesClient.iTunesResponseKeys.ArtworkUrl60] as? String
        artworkUrl100 = dictionary[iTunesClient.iTunesResponseKeys.ArtworkUrl100] as? String
        collectionCensoredName = dictionary[iTunesClient.iTunesResponseKeys.СollectionCensoredName] as? String
        collectionExplicitness = dictionary[iTunesClient.iTunesResponseKeys.CollectionExplicitness] as? Bool
        collectionId = dictionary[iTunesClient.iTunesResponseKeys.CollectionId] as? Int16
        collectionName = dictionary[iTunesClient.iTunesResponseKeys.СollectionName] as? String
        collectionPrice = dictionary[iTunesClient.iTunesResponseKeys.CollectionPrice] as? Double
        collectionViewUrl = dictionary[iTunesClient.iTunesResponseKeys.CollectionViewUrl] as? String
        country = dictionary[iTunesClient.iTunesResponseKeys.Country] as? String
        currency = dictionary[iTunesClient.iTunesResponseKeys.Currency] as? String
        discCount = dictionary[iTunesClient.iTunesResponseKeys.DiscCount] as? Int16
        discNumber = dictionary[iTunesClient.iTunesResponseKeys.DiscNumber] as? Int16
        kind = dictionary[iTunesClient.iTunesResponseKeys.Kind] as? String
        previewUrl = dictionary[iTunesClient.iTunesResponseKeys.PreviewUrl] as? String
        primaryGenreName = dictionary[iTunesClient.iTunesResponseKeys.PrimaryGenreName] as? String
        trackCensoredName = dictionary[iTunesClient.iTunesResponseKeys.TrackCensoredName] as? String
        trackCount = dictionary[iTunesClient.iTunesResponseKeys.TrackCount] as? Int16
        trackExplicitness = dictionary[iTunesClient.iTunesResponseKeys.TrackExplicitness] as? Bool
        trackId = dictionary[iTunesClient.iTunesResponseKeys.TrackId] as? Int16
        trackName = dictionary[iTunesClient.iTunesResponseKeys.TrackName] as? String
        trackNumber = dictionary[iTunesClient.iTunesResponseKeys.TrackNumber] as? Int16
        trackPrice = dictionary[iTunesClient.iTunesResponseKeys.TrackPrice] as? Double
        trackTimeMillis = dictionary[iTunesClient.iTunesResponseKeys.TrackTimeMillis] as? Int16
        trackViewUrl = dictionary[iTunesClient.iTunesResponseKeys.TrackViewUrl] as? String
        wrapperType = dictionary[iTunesClient.iTunesResponseKeys.Wrapper] as? String
    }
    
    static func iTunesResultFromResults(_ results: [[String:AnyObject]]) -> [iTunesResult] {
        
        var iTunesResults = [iTunesResult]()
        
        // iterate through array of dictionaries, each iTunesResult is a dictionary
        for result in results {
            iTunesResults.append(iTunesResult(dictionary: result))
        }
        
        return iTunesResults
    }
}

// MARK: - iTunesResult: Equatable

extension iTunesResult: Equatable {}

func ==(lhs: iTunesResult, rhs: iTunesResult) -> Bool {
    return lhs.artistId == rhs.artistId
}
