//
//  RMListViewModelTests.swift
//  Rich n MortyTests
//
//  Created by Kevin on 2022-04-08.
//

import XCTest
@testable import Rich_n_Morty

class RMListViewModelTests: XCTestCase {
    var serviceProviderMock: RMServiceProviderMock?
    var vcMock: RMCharactersVCMock?
    var viewModel: RMListViewModel?

    override func setUp() {
        super.setUp()
        serviceProviderMock = RMServiceProviderMock()
        viewModel = RMListViewModel(provider: serviceProviderMock!)
        vcMock = RMCharactersVCMock(viewModel!)
    }
    
    override func tearDown() {
        serviceProviderMock = nil
        viewModel = nil
        vcMock = nil
    }
    
    func testViewModelStateUpdateHandler() {
        guard let vcMock = vcMock else {
            XCTFail("vcMock is nil")
            return
        }
 
        vcMock.receivedState = .emptyList
        // update to displayAlert
        viewModel?.state = .displayAlert("")
        XCTAssertTrue(vcMock.receivedState.isDisplayAlert)
        // update to emptyList
        viewModel?.state = .emptyList
        XCTAssertTrue(vcMock.receivedState.isEmptyList)
        // update to characters
        viewModel?.state = .charactersUpdated([])
        XCTAssertTrue(vcMock.receivedState.isCharactersUpdated)
    }
    
    func testFetchCharacter() {
        guard let serviceProvider = serviceProviderMock else {
            XCTFail("Service Provider is not ready")
            return
        }
        
        // set reponse to characters
        serviceProvider.mockResponseType = .characters
        
        let expectation = self.expectation(description: "")
        serviceProvider.requestCharacters { result in
            if case let .success(responseModel) = result {
                XCTAssertEqual(responseModel.results.count, 2)
                expectation.fulfill()
            } else {
                XCTFail("Unexpected failure received")
            }
        }
        
        // wait max of 2 seconds
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchCharacterWithEmptyResponse() {
        guard let serviceProvider = serviceProviderMock else {
            XCTFail("Service Provider is not ready")
            return
        }
        
        // set reponse to empty
        serviceProvider.mockResponseType = .empty
        
        let expectation = self.expectation(description: "")
        serviceProvider.requestCharacters { result in
            if case let .success(responseModel) = result {
                XCTAssertEqual(responseModel.results.count, 0)
                expectation.fulfill()
            } else {
                XCTFail("Unexpected failure received")
            }
        }
        
        // wait max of 2 seconds
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchCharacterWithMailformedResponse() {
        guard let serviceProvider = serviceProviderMock else {
            XCTFail("Service Provider is not ready")
            return
        }
        
        // set reponse to malformed response
        serviceProvider.mockResponseType = .malformedCharacterResponse
        
        let expectation = self.expectation(description: "")
        serviceProvider.requestCharacters { result in
            if case let .failure(error) = result {
                if case .decodingError(_) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error received")
                }
            } else {
                XCTFail("Unexpected failure received")
            }
        }
        
        // wait max of 2 seconds
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchCharacterWithUrlRequestError() {
        guard let serviceProvider = serviceProviderMock else {
            XCTFail("Service Provider is not ready")
            return
        }
        
        // defining an error
        serviceProvider.spError = .urlRequestError("")
        
        let expectation = self.expectation(description: "")
        serviceProvider.requestCharacters { result in
            if case let .failure(error) = result {
                if case .urlRequestError(_) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error received")
                }
            } else {
                XCTFail("Unexpected failure received")
            }
        }
        
        // wait max of 2 seconds
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    
}


// RMListStates comparison without making change to original enum
fileprivate extension RMListViewModel.RMListStates {
    var isEmptyList: Bool {
        if case .emptyList = self {
            return true
        } else {
            return false
        }
    }
    var isDisplayAlert: Bool {
        if case .displayAlert(_) = self {
            return true
        } else {
            return false
        }
    }
    var isCharactersUpdated: Bool {
        if case .charactersUpdated(_) = self {
            return true
        } else {
            return false
        }
    }
}
