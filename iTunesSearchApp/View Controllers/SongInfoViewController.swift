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
    @IBOutlet var artistName: UILabel!
    @IBOutlet var artistNameButton: UIButton!
    @IBOutlet var collectionName: UILabel!
    @IBOutlet var collectionNameButton: UIButton!
    @IBOutlet var trackName: UILabel!
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
            self.artistName.text = "Artist: \(artistName).\n"
            self.collectionName.text = "Collection: \(collectionName).\n"
            self.trackName.text = "Track name: \(trackName).\n"
            let collectionPrice = "Collection price: \(result.collectionPrice).\n"
            let collectionExplicitness = (result.collectionExplicitness) ? "Collection explicit: Yes.\n" : "Collection explicit: No.\n"
            let country = (country.count > 0) ? "Country: \(country).\n" : ""
            let discCount = "Disc count: \(result.discCount).\n"
            let discNumber = "Disc count: \(result.discNumber).\n"
            let genre = (genre.count > 0) ? "Genre: \(genre).\n" : ""
            let trackPrice = "Track price: \(result.trackPrice).\n"
            let trackExplicitness = (result.trackExplicitness) ? "Track explicit: Yes.\n" : "Track explicit: No.\n"
            let trackNumber = "Track number: \(result.trackNumber).\n"
            let trackTime = "Track time: \(result.trackTimeMillis).\n"
            self.textView.text = "\(collectionPrice)\(collectionExplicitness)\(country)\(discCount)\(discNumber)\(genre)\(trackPrice)\(trackExplicitness)\(trackNumber)\(trackTime)"
        }
    }
    
    private func openUrl(url: String) {
        UIApplication.shared.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
    }
    
}

