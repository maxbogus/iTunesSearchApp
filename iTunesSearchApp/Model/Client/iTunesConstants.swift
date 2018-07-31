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
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: iTunes Parameter Keys
    struct iTunesParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
    }
    
    // MARK: iTunes Parameter Values
    struct iTunesParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "f0dad750eaeb897ef50c8e95846423d7"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let GalleryID = "5704-72157622566655097"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        static let PerPageValue = "20"
    }
    
    // MARK: iTunes Response Keys
    struct iTunesResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: iTunes Response Values
    struct iTunesResponseValues {
        static let OKStatus = "ok"
    }
    
}
