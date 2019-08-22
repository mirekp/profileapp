//
//  MockNetworkService.swift
//  profileappTests
//
//  Created by Mirek Petricek on 22/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import Foundation
import XCTest
@testable import profileapp

class MockNetworkService: NetworkService {
    var getProfileExpectation: XCTestExpectation?
    var getProfileReturns: Result<Profile, NetworkService.Errors>?
    override func getProfile(_ completion: @escaping (Result<Profile, NetworkService.Errors>) -> Void) {
        guard let getProfileReturns = getProfileReturns else {
            assertionFailure("getProfileReturns not configured")
            return
        }
        completion(getProfileReturns)
        getProfileExpectation?.fulfill()
    }
}
