//
//  ProfileViewInteractorTests.swift
//  profileappTests
//
//  Created by Mirek Petricek on 22/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import XCTest
@testable import profileapp

class ProfileViewInteractorTests: XCTestCase {
    
    var interactor: ProfileViewInteractor!
    var mockPresenter: MockProfilePresenter!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockPresenter = MockProfilePresenter()
        interactor = ProfileViewInteractor(mockPresenter, networkService: mockNetworkService)
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testLoadData_setsAndUnsetsLoadingState() {
        //given
        let getprofileCalledExpectation = XCTestExpectation(description: "getProfileCalled")
        mockNetworkService.getProfileReturns = .success(validProfile)
        mockNetworkService.getProfileExpectation = getprofileCalledExpectation
        
        //when
        interactor.loadData()
        
        //then
        XCTAssertEqual(mockPresenter.enterLoadingStateCallCount, 1)
        wait(for: [getprofileCalledExpectation], timeout: 3.0)
        XCTAssertEqual(mockPresenter.exitLoadingStateCallCount, 1)
    }
    
    func testLoadData_callsIntoPresenter_onSuccess() {
        //given
        let getprofileCalledExpectation = XCTestExpectation(description: "getProfileCalled")
        mockNetworkService.getProfileReturns = .success(validProfile)
        mockNetworkService.getProfileExpectation = getprofileCalledExpectation
        
        //when
        interactor.loadData()
        
        //then
        guard let retrievedProfile = mockPresenter.showDataArgsForCall.last else {
            XCTFail()
            return
        }
        XCTAssertEqual(retrievedProfile, validProfile)
    }
    
    func testLoadData_callsIntoPresenter_onFailure() {
        //given
        let getprofileCalledExpectation = XCTestExpectation(description: "getProfileCalled")
        mockNetworkService.getProfileReturns = .failure(.httpError)
        mockNetworkService.getProfileExpectation = getprofileCalledExpectation
        
        //when
        interactor.loadData()
        
        //then
        guard let retrievedError = mockPresenter.showErrorArgsForCall.last else {
            XCTFail()
            return
        }
        XCTAssertEqual(retrievedError, "Unable to load data from network. Please check your network connection and try again.")
    }
    
    private var validProfile = Profile(name: "aaaa", summary: "bbbb", workExperience: [])
}
