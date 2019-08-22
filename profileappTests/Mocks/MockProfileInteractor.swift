//
//  MockProfileInteractor.swift
//  profileappTests
//
//  Created by Mirek Petricek on 22/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import Foundation
@testable import profileapp

class MockProfileInteractor: ProfileViewInteractionLogic {
    var loadDataCallCount = 0
    func loadData() {
        loadDataCallCount += 1
    }
}
