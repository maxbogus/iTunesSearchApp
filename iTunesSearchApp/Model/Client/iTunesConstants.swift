//
//  iTunesConstants.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 01/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

// MARK: - iTunesClient (Constants)

extension iTunesClient {
    
    // MARK: iTunes
    struct Constants {
        static let APIScheme = "https"
        static let APIHost = "itunes.apple.com"
        static let APIPath = "/"
    }
    
    // MARK: iTunes Parameter Keys
    struct iTunesParameterKeys {
        static let Search = "search"
        static let Lookup = "search"
        static let Term = "term"
        static let Country = "country"
        static let Media = "media"
        static let Entity = "entity"
        static let Attribute = "attribute"
        static let Callback = "callback"
        static let Limit = "limit"
        static let Lang = "lang"
        static let Version = "version"
        static let Explicit = "explicit"
    }
    
    // MARK: iTunes Parameter Values
    struct iTunesParameterValues {
        static let Country = "US"
        static let Media = "all"
        static let Entity = "music"
        static let Attribute = "all" /* 1 means "yes" */
        static let Limit = "25"
        static let Lang = "en_us"
        static let Version = "2"
        static let Explicit = "No"
    }
    
    // MARK: iTunes Response Keys
    struct iTunesResponseKeys {
        static let Results = "results"
        static let ResultsCount = "resultCount"
        static let Wrapper = "wrapperType"
        static let Kind = "kind"
        static let ArtistId = "artistId"
        static let CollectionId = "collectionId"
        static let TrackId = "trackId"
        static let ArtistName = "artistName"
        static let СollectionName = "collectionName"
        static let TrackName = "trackName"
        static let СollectionCensoredName = "collectionCensoredName"
        static let TrackCensoredName = "trackCensoredName"
        static let ArtistViewUrl = "artistViewUrl"
        static let CollectionViewUrl = "collectionViewUrl"
        static let TrackViewUrl = "trackViewUrl"
        static let PreviewUrl = "previewUrl"
        static let ArtworkUrl60 = "artworkUrl60"
        static let ArtworkUrl100 = "artworkUrl100"
        static let CollectionPrice = "collectionPrice"
        static let TrackPrice = "trackPrice"
        static let CollectionExplicitness = "collectionExplicitness"
        static let TrackExplicitness = "trackExplicitness"
        static let DiscCount = "discCount"
        static let DiscNumber = "discNumber"
        static let TrackCount = "trackCount"
        static let TrackNumber = "trackNumber"
        static let TrackTimeMillis = "trackTimeMillis"
        static let Country = "country"
        static let Currency = "currency"
        static let PrimaryGenreName = "primaryGenreName"
        
    }
    
    // MARK: iTunes Response Values
    struct iTunesResponseValues {
        static let OKStatus = "ok"
    }
    
}
