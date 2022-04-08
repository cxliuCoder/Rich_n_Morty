//
//  RMListViewModel.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-07.
//

import UIKit

class RMListViewModel {
    // states of the Character list
    enum RMListStates {
        case emptyList
        case charactersUpdated([CharacterModel])
        case displayAlert(String)
    }
    
    // ServiceProvider that conforms ServiceProvidable protocol
    var serviceProvider: RMServiceProvidable
    
    typealias ServiceRequestCompletionHandler = (Result<RMCharacterResponseModel, RMServiceProviderError>) -> ()
    
    var characters = [CharacterModel]()
    var state: RMListStates = .emptyList {
        didSet {
            stateUpdateHandler(state)
        }
    }
    
    // Injection of serviceProvider
    init(provider: RMServiceProvidable) {
        serviceProvider = provider
    }
    
    lazy var stateUpdateHandler: (RMListStates) -> () = {_ in }
    
    /// Async fetch characters with options to request different response
    /// When finished, self.characters will be updated
    func fetchCharacters(count: Int) {
        serviceProvider.requestCharacters() { [weak self] result in
            guard let self = self else {
                print("[RMListViewModel] self was destroyed")
                return
            }
            
            switch result {
            case .failure(let error):
                // clear characters
                self.characters.removeAll()
                // display provider error by updating state
                self.state = .displayAlert(error.errorMessage)
            case .success(let characterResponseModel):                self.characters = characterResponseModel.results
                /// When count is less than the received characters, only store the requested number of characters
                /// When count is larger than the received characters, discussion should be made with the API team to reduce server request frequency.
                if self.characters.count > count {
                    self.characters = Array(self.characters[..<count])
                }
                
                // update to view
                self.state = .charactersUpdated(self.characters)
            }
        }
    }
    
    
}
