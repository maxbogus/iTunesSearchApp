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
    @IBOutlet var collectionPrice: UILabel!
    @IBOutlet var collectionExplicitness: UILabel!
    @IBOutlet var country: UILabel!
    @IBOutlet var discCount: UILabel!
    @IBOutlet var discNumber: UILabel!
    @IBOutlet var genre: UILabel!
    @IBOutlet var trackName: UILabel!
    @IBOutlet var trackNameButton: UIButton!
    @IBOutlet var trackPrice: UILabel!
    @IBOutlet var trackExplicitness: UILabel!
    @IBOutlet var trackNumber: UILabel!
    @IBOutlet var trackTime: UILabel!

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
            print(artwork)
            self.artistName.text = "Artist: \(artistName)"
            self.collectionName.text = "Collection: \(collectionName)"
            self.collectionPrice.text = "Collection price: \(result.collectionPrice)"
            self.collectionExplicitness.text = (result.collectionExplicitness) ? "Collection explicit: Yes" : "Collection explicit: No"
            self.country.text = "Country: \(country)"
            self.discCount.text = "Disc count: \(result.discCount)"
            self.discNumber.text = "Disc count: \(result.discNumber)"
            self.genre.text = "Genre: \(genre)"
            self.trackName.text = "Track name: \(trackName)"
            self.trackPrice.text = "Track price: \(result.trackPrice)"
            self.trackExplicitness.text = (result.trackExplicitness) ? "Track explicit: Yes" : "Track explicit: No"
            self.trackNumber.text = "Track number: \(result.trackNumber)"
            self.trackTime.text = "Track time: \(result.trackTimeMillis)"
        }
    }
    
    private func openUrl(url: String) {
        UIApplication.shared.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
    }
    
}

