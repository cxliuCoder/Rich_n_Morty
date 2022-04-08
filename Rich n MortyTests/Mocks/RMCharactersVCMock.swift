//
//  RMCharactersVCMock.swift
//  Rich n MortyTests
//
//  Created by Kevin on 2022-04-08.
//

import UIKit
@testable import Rich_n_Morty

class RMCharactersVCMock {
    var viewModel: RMListViewModel?
    var receivedState: RMListViewModel.RMListStates = .emptyList
    
    // init with view model and bind state updateHandler with it
    init(_ vm: RMListViewModel) {
        viewModel = vm
        vm.stateUpdateHandler = { state in
            self.receivedState = state
        }
    }
}
