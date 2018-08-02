//
//  SongInfoViewController.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 02/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import UIKit

class SongInfoViewController: UIViewController {
    @IBOutlet var artwork: UIImageView!
    @IBOutlet var artistName: UILabel!
    @IBOutlet var collectionName: UILabel!
    @IBOutlet var trackName: UILabel!
    
    @IBOutlet var artistNameButton: UIButton!
    @IBOutlet var collectionNameButton: UIButton!
    @IBOutlet var trackNameButton: UIButton!
    
    @IBOutlet var collectionPrice: UILabel!
    @IBOutlet var trackPrice: UILabel!
    @IBOutlet var collectionExplicitness: UILabel!
    @IBOutlet var trackExplicitness: UILabel!
    @IBOutlet var discCount: UILabel!
    @IBOutlet var discNumber: UILabel!
    @IBOutlet var trackNumber: UILabel!
    @IBOutlet var trackTime: UILabel!
    @IBOutlet var country: UILabel!
    @IBOutlet var genre: UILabel!
    
    @IBAction func viewArtistInItunes(_ sender: Any) {
    }
    @IBAction func viewCollectionInItunes(_ sender: Any) {
    }
    @IBAction func viewTrackInItunes(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

