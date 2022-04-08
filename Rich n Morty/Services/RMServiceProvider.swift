//
//  RMServiceProvider.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-07.
//

import UIKit

class RMServiceProvider: RMServiceProvidable {
    
    func requestCharacters(completionHandler: ServiceCompletionHandler?) {
        guard let requestUrl = URL(string: Constants.characterUrlStr) else {
            print("[RMServiceProvider] Service provider endpoint url invalid")
            completionHandler?(.failure(.serviceURLInvalid))
            return
        }
        let serviceRequest = URLRequest(url: requestUrl)
        URLSession.shared.request(with: serviceRequest) { result in
            switch result {
            case .failure(let error):
                // request error
                print(error.errorMessage)
                completionHandler?(.failure(.urlRequestError(error.errorMessage)))
            case .success(let data):
                // try parse response to RMCharacterResponseModel
                do {
                    let characterList = try JSONDecoder().decode(RMCharacterResponseModel.self, from: data)
                    completionHandler?(.success(characterList))
                } catch {
                    print("Parsing characterList with error:\n\(error)")
                    completionHandler?(.failure(.decodingError("Received malformed character data")))
                }
            }
        }
    }
}

extension RMServiceProvider {
    struct Constants {
        static let characterUrlStr = "https://rickandmortyapi.com/api/character"
    }
}
