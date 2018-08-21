//
//  SongInfoViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SongInfoViewController: UIViewController {
    @IBOutlet var artwork: UIImageView!
    @IBOutlet var artistNameButton: UIButton!
    @IBOutlet var collectionNameButton: UIButton!
    @IBOutlet var trackNameButton: UIButton!
    @IBOutlet var textView: UITextView!

    var dataController: DataController!
    var result: SearchResult!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let result = self.result {
            populateView(result: result)
        }
    }
    
    @IBAction func viewArtistInItunes(_ sender: Any) {
        if let result = self.result {
            if let url = result.artistViewUrl {
                self.openUrl(url: url)
            }
        }
    }

    @IBAction func viewCollectionInItunes(_ sender: Any) {
        if let result = self.result {
            if let url = result.collectionViewUrl {
                self.openUrl(url: url)
            }
        }
    }

    @IBAction func viewTrackInItunes(_ sender: Any) {
        if let result = self.result {
            if let url = result.trackViewUrl {
                self.openUrl(url: url)
            }
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func populateView(result: SearchResult) {
        if let artwork = result.artworkUrl100, let artistName = result.artistName, let collectionName = result.collectionName, let country = result.country, let genre = result.primaryGenreName, let trackName = result.trackName {
            let artistName = "Artist: \(artistName). "
            let collectionName = "Collection: \(collectionName). "
            let trackName = "Track name: \(trackName). "
            let collectionPrice = "Collection price: \(result.collectionPrice). "
            let collectionExplicitness = (result.collectionExplicitness) ? "Collection explicit: Yes. " : "Collection explicit: No. "
            let country = (country.count > 0) ? "Country: \(country). " : ""
            let discCount = "Disc count: \(result.discCount). "
            let discNumber = "Disc number: \(result.discNumber). "
            let genre = (genre.count > 0) ? "Genre: \(genre). " : ""
            let trackPrice = "Track price: \(result.trackPrice). "
            let trackExplicitness = (result.trackExplicitness) ? "Track explicit: Yes. " : "Track explicit: No. "
            let trackNumber = "Track number: \(result.trackNumber). "
            let trackTime = "Track time: \(result.trackTimeMillis). "
            self.textView.text = "\(artistName)\n\(trackName)\n\(country)\(genre)\(trackPrice)\(trackExplicitness)\(trackNumber)\(trackTime)\n\(collectionName)\n\(collectionPrice)\(collectionExplicitness)\n\(discCount)\(discNumber)"
        }
    }
    
    private func openUrl(url: String) {
        UIApplication.shared.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
    }
    
}

