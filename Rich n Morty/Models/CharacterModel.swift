//
//  CharacterModel.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-06.
//

import UIKit

struct CharacterModel: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let currentLocation: LocationModel
    let image: String
    let episode: [String]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case gender
        case currentLocation = "location"
        case image
        case episode
    }
    init(id: Int, name: String, status: String, species: String, gender: String, currentLocation: LocationModel, image: String, episode: [String]) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.currentLocation = currentLocation
        self.image = image
        self.episode = episode
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try rootContainer.decode(Int.self, forKey: .id)
        name = try rootContainer.decode(String.self, forKey: .name)
        status = try rootContainer.decode(String.self, forKey: .status)
        species = try rootContainer.decode(String.self, forKey: .species)
        gender = try rootContainer.decode(String.self, forKey: .gender)
        currentLocation = try rootContainer.decode(LocationModel.self, forKey: .currentLocation)
        image = try rootContainer.decode(String.self, forKey: .image)
        episode = try rootContainer.decode([String].self, forKey: .episode)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(status, forKey: .status)
        try container.encode(species, forKey: .species)
        try container.encode(gender, forKey: .gender)
        try container.encode(currentLocation, forKey: .currentLocation)
        try container.encode(image, forKey: .image)
        try container.encode(episode, forKey: .episode)
    }
}
