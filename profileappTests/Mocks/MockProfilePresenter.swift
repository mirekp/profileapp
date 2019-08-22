//
//  MockProfilePresenter.swift
//  profileappTests
//
//  Created by Mirek Petricek on 22/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import Foundation
@testable import profileapp

class MockProfilePresenter: ProfileViewPresentationLogic {
    
    var showDataArgsForCall = [Profile]()
    func showData(_ profile: Profile) {
        showDataArgsForCall.append(profile)
    }
    
    var showErrorArgsForCall = [String]()
    func showError(_ errorText: String) {
        showErrorArgsForCall.append(errorText)
    }
    
    var enterLoadingStateCallCount = 0
    func enterLoadingState() {
        enterLoadingStateCallCount += 1
    }
    
    var exitLoadingStateCallCount = 0
    func exitLoadingState() {
        exitLoadingStateCallCount += 1
    }
}
