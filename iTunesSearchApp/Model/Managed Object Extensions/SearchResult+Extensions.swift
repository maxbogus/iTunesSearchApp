//
//  SearchResult.swift
//  iTunesSearchApp
//
//  Created by Max Boguslavskiy on 15/08/2018.
//  Copyright © 2018 Max Boguslavskiy. All rights reserved.
//

import Foundation
import CoreData

extension SearchResult {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
}
