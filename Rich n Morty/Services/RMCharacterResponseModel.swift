//
//  RMServiceResponseModel.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-06.
//

import UIKit

struct RMCharacterResponseModel: Codable {
    let info: RMCharacterResponseInfoModel
    let results: [CharacterModel]
    
    enum CodingKeys: String, CodingKey {
        case info
        case results
    }
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RMCharacterResponseModel.self, from: data)
        self = decoded
    }
}

struct RMCharacterResponseInfoModel: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
