//
//  ProfileViewController.swift
//  profileapp
//
//  Created by Mirek Petricek on 21/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    var interactor: ProfileViewInteractionLogic!
    private var viewModel: Profile? {
        didSet {
            profileNameLabel.text = viewModel?.name
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor = ProfileViewInteractor(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.loadData()
    }
}
    
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel != nil ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Profile"
        case 1:
            return "Work Experience"
        default:
            assertionFailure()
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "WorkExperienceCell", for: indexPath)
        default:
            assertionFailure()
            cell = UITableViewCell()
        }
        
        configure(cell, forRowAt: indexPath)
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            assertionFailure()
            return
        }
        if let cell = cell as? ProfileCell {
            cell.configure(viewModel)
        }
        else if let cell = cell as? WorkExperienceCell {
            cell.configure(viewModel.workExperience[indexPath.row])
        }
        else {
            assertionFailure()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.workExperience.count
        default:
            assertionFailure()
            return 0
        }
    }
}

extension ProfileViewController: ProfileViewPresentationLogic {
    func enterLoadingState() {
        spinner?.startAnimating()
    }
    
    func exitLoadingState() {
        spinner?.stopAnimating()
    }
    
    func showError(_ errorText: String) {
        let alert = UIAlertController(title: "Something went wrong", message: errorText, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.interactor.loadData()
        })
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showData(_ profile: Profile) {
        viewModel = profile
    }
}
