//
//  RMServiceProviderMock.swift
//  Rich n MortyTests
//
//  Created by Kevin on 2022-04-08.
//

import UIKit
@testable import Rich_n_Morty

class RMServiceProviderMock: RMServiceProvidable {
    enum ResponseType {
        case empty
        case malformedCharacterResponse
        case characters
    }
    
    var spError: RMServiceProviderError?
    
    private var characterResponse =
        """
        {
          "info": {
            "count": 2,
            "pages": 1,
            "next": null,
            "prev": null
          },
          "results": [
            {
              "id": 1,
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
              ],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            },
            {
              "id": 2,
              "name": "Morty Smith",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "unknown",
                "url": ""
              },
              "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
              ],
              "url": "https://rickandmortyapi.com/api/character/2",
              "created": "2017-11-04T18:50:21.651Z"
            }
          ]
        }
        """
    private var malformedCharacterResponse = """
        {
          "info": "This is a malformed character response"
        }
        """
    
    private var emptyCharacterResponse = """
        {
          "info": {
            "count": 2,
            "pages": 1,
            "next": null,
            "prev": null
          },
          "results": []
        }
        """
    
    // Set it to mock next response type
    var mockResponseType: ResponseType = .characters
    
    func requestCharacters(completionHandler: ServiceCompletionHandler?) {
        // if service provider error cases
        if let error = spError {
            completionHandler?(.failure(error))
            return
        }
        
        var responseData: Data
        switch mockResponseType {
        case .characters:
            responseData = characterResponse.data(using: .utf8) ?? Data()
        case .malformedCharacterResponse:
            responseData = malformedCharacterResponse.data(using: .utf8) ?? Data()
        case .empty:
            responseData = emptyCharacterResponse.data(using: .utf8) ?? Data()
        }
        
        if let responseModel = try? RMCharacterResponseModel(data: responseData) {
            completionHandler?(.success(responseModel))
        } else {
            completionHandler?(.failure(.decodingError("")))
        }
    }
}
