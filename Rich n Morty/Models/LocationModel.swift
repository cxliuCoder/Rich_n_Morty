//
//  LocationModel.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-07.
//

import UIKit

struct LocationModel: Codable, Equatable {
    let name: String
    let url: String
    
    // unknown initializer
    init() {
        name = "unknown"
        url = ""
    }
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
