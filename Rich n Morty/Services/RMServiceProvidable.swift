//
//  RMServiceProvidable.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-06.
//

import UIKit

enum RMServiceProviderError: Error {
    case serviceURLInvalid
    case urlRequestError(String)
    case decodingError(String)
    
    var errorMessage: String {
        var message = ""
        switch self {
        case .serviceURLInvalid:
            message = "Service request url invalid"
        case .urlRequestError(let errorStr):
            message = "Request received error: (\(errorStr)"
        case .decodingError(let errorStr):
            message = "Could not decode responseData: (\(errorStr)"
        }
        return message
    }
}

protocol RMServiceProvidable {
    typealias ServiceCompletionHandler = (Result<RMCharacterResponseModel, RMServiceProviderError>) -> ()
    
    /// Request number of characters from the endpoint
    func requestCharacters(completionHandler: ServiceCompletionHandler?)
}
