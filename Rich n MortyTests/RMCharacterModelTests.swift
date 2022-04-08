//
//  RMCharacterModelTests.swift
//  Rich n MortyTests
//
//  Created by Kevin on 2022-04-06.
//

import XCTest
@testable import Rich_n_Morty

class RMCharacterModelTests: XCTestCase {
    let mockCharacterJson = """
        {
            "id" : 1,
            "name" : "Rick Sanchez",
            "status" : "Alive",
            "species" : "Human",
            "type" : "",
            "gender" : "Male",
            "origin" : {
                "name" : "Earth (C-137)",
                "url" : "https://rickandmortyapi.com/api/location/1"
            },
            "location" : {
                "name" : "Citadel of Ricks",
                "url" : "https://rickandmortyapi.com/api/location/3"
            },
            "image" : "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode" : [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2",
                "https://rickandmortyapi.com/api/episode/3",
                "https://rickandmortyapi.com/api/episode/4"
            ],
            "url" : "https://rickandmortyapi.com/api/character/1",
            "created" : "2017-11-04T18:48:46.250Z"
        }
        """
    
    let mockCharacter = CharacterModel(id: 1,
                                       name: "Rick Sanchez",
                                       status: "Alive",
                                       species: "Human",
                                       gender: "Male",
                                       currentLocation: LocationModel(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
                                       image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                       episode: ["https://rickandmortyapi.com/api/episode/1",
                                                 "https://rickandmortyapi.com/api/episode/2",
                                                 "https://rickandmortyapi.com/api/episode/3",
                                                 "https://rickandmortyapi.com/api/episode/4"])
    
    func testEncoding() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try JSONEncoder().encode(mockCharacter)

        guard let jsonString = String(data: data, encoding: .utf8) else {
            XCTFail("Failed to decode JSON data using .utf8")
            return
        }
        XCTAssertEqual(jsonString,
                       "{\"status\":\"Alive\",\"gender\":\"Male\",\"location\":{\"name\":\"Citadel of Ricks\",\"url\":\"https:\\/\\/rickandmortyapi.com\\/api\\/location\\/3\"},\"id\":1,\"image\":\"https:\\/\\/rickandmortyapi.com\\/api\\/character\\/avatar\\/1.jpeg\",\"species\":\"Human\",\"episode\":[\"https:\\/\\/rickandmortyapi.com\\/api\\/episode\\/1\",\"https:\\/\\/rickandmortyapi.com\\/api\\/episode\\/2\",\"https:\\/\\/rickandmortyapi.com\\/api\\/episode\\/3\",\"https:\\/\\/rickandmortyapi.com\\/api\\/episode\\/4\"],\"name\":\"Rick Sanchez\"}")
    }
    
    func testDecoding() {
        guard let mockCharacterData = mockCharacterJson.data(using: .utf8) else {
            XCTFail("Failed to encode mockCharacterData using .utf8")
            return
        }
        
        guard let decoded = try? JSONDecoder().decode(CharacterModel.self, from: mockCharacterData) else {
            XCTFail("Unable to decode mockCharacterData to 'CharacterModel'")
            return
        }
        
        XCTAssertEqual(mockCharacter.id, decoded.id)
        XCTAssertEqual(mockCharacter.name, decoded.name)
        XCTAssertEqual(mockCharacter.status, decoded.status)
        XCTAssertEqual(mockCharacter.species, decoded.species)
        XCTAssertEqual(mockCharacter.gender, decoded.gender)
        XCTAssertEqual(mockCharacter.currentLocation, decoded.currentLocation)
        XCTAssertEqual(mockCharacter.image, decoded.image)
        XCTAssertEqual(mockCharacter.episode, decoded.episode)
    }
}
