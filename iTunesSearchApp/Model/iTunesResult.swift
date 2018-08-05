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
    
    let wrapperType: String?
    let kind: String?
    let artistId: Double?
    let collectionId: Double?
    let trackId: Double?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Double?
    let discNumber: Double?
    let trackCount: Double?
    let trackNumber: Double?
    let trackTimeMillis: Double?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    
    // MARK: Initializers
    
    // construct a iTunesResult from a dictionary
    init(dictionary: [String:AnyObject]) {
        wrapperType = dictionary[iTunesClient.iTunesResponseKeys.Wrapper] as? String
        kind = dictionary[iTunesClient.iTunesResponseKeys.Kind] as? String
        artistId = dictionary[iTunesClient.iTunesResponseKeys.ArtistId] as? Double
        collectionId = dictionary[iTunesClient.iTunesResponseKeys.CollectionId] as? Double
        trackId = dictionary[iTunesClient.iTunesResponseKeys.TrackId] as? Double
        artistName = dictionary[iTunesClient.iTunesResponseKeys.ArtistName] as? String
        collectionName = dictionary[iTunesClient.iTunesResponseKeys.СollectionName] as? String
        trackName = dictionary[iTunesClient.iTunesResponseKeys.TrackName] as? String
        collectionCensoredName = dictionary[iTunesClient.iTunesResponseKeys.СollectionCensoredName] as? String
        trackCensoredName = dictionary[iTunesClient.iTunesResponseKeys.TrackCensoredName] as? String
        artistViewUrl = dictionary[iTunesClient.iTunesResponseKeys.ArtistViewUrl] as? String
        collectionViewUrl = dictionary[iTunesClient.iTunesResponseKeys.CollectionViewUrl] as? String
        trackViewUrl = dictionary[iTunesClient.iTunesResponseKeys.TrackViewUrl] as? String
        previewUrl = dictionary[iTunesClient.iTunesResponseKeys.PreviewUrl] as? String
        artworkUrl60 = dictionary[iTunesClient.iTunesResponseKeys.ArtworkUrl60] as? String
        artworkUrl100 = dictionary[iTunesClient.iTunesResponseKeys.ArtworkUrl100] as? String
        collectionPrice = dictionary[iTunesClient.iTunesResponseKeys.CollectionPrice] as? Double
        trackPrice = dictionary[iTunesClient.iTunesResponseKeys.TrackPrice] as? Double
        collectionExplicitness = dictionary[iTunesClient.iTunesResponseKeys.CollectionExplicitness] as? String
        trackExplicitness = dictionary[iTunesClient.iTunesResponseKeys.TrackExplicitness] as? String
        discCount = dictionary[iTunesClient.iTunesResponseKeys.DiscCount] as? Double
        discNumber = dictionary[iTunesClient.iTunesResponseKeys.DiscNumber] as? Double
        trackCount = dictionary[iTunesClient.iTunesResponseKeys.TrackCount] as? Double
        trackNumber = dictionary[iTunesClient.iTunesResponseKeys.TrackNumber] as? Double
        trackTimeMillis = dictionary[iTunesClient.iTunesResponseKeys.TrackTimeMillis] as? Double
        country = dictionary[iTunesClient.iTunesResponseKeys.Country] as? String
        currency = dictionary[iTunesClient.iTunesResponseKeys.Currency] as? String
        primaryGenreName = dictionary[iTunesClient.iTunesResponseKeys.PrimaryGenreName] as? String
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
