//
//  ProfileViewInteractor.swift
//  profileapp
//
//  Created by Mirek Petricek on 21/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import Foundation

protocol ProfileViewInteractionLogic {
    func loadData()
}

protocol ProfileViewPresentationLogic: class {
    func showData(_ profile: Profile)
    func showError(_ errorText: String)
    func enterLoadingState()
    func exitLoadingState()
}

class ProfileViewInteractor: ProfileViewInteractionLogic {
    
    private weak var presenter: ProfileViewPresentationLogic?
    private let networkService: NetworkService
    
    init(_ presenter: ProfileViewPresentationLogic, networkService: NetworkService = NetworkService()) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    func loadData() {
        presenter?.enterLoadingState()
        networkService.getProfile { [weak presenter] result in
            presenter?.exitLoadingState()
            switch result {
            case .success(let profile):
                presenter?.showData(profile)
            case .failure(_):
                presenter?.showError("Unable to load data from network. Please check your network connection and try again.")
            }
        }
    }
}
