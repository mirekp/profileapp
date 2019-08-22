//
//  ProfileViewControllerTests.swift
//  profileappTests
//
//  Created by Mirek Petricek on 21/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import XCTest
@testable import profileapp

class ProfileViewControllerTests: XCTestCase {
    
    var vc: ProfileViewController!
    var mockInteractor: MockProfileInteractor!
    var label: UILabel!
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        mockInteractor = MockProfileInteractor()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        label = UILabel()
        tableView = UITableView()
        vc.profileNameLabel = label
        vc.tableView = tableView
        vc.interactor = mockInteractor
    }

    override func tearDown() {
        
        super.tearDown()
    }

    func testItCallsToServiceOnAppear() {
        // given
        
        // when
        vc.viewWillAppear(false)
        
        // then
        XCTAssertEqual(mockInteractor.loadDataCallCount, 1)
    }
    
    func testProperlySetsTableViewSource() {
        // given
        let workExperience = Profile.WorkExperience(client: "a client", location: "a location", from: Date(), to: Date(), role: "a role", summary: "a summary")
        let profile = Profile(name: "blah", summary: "blahblah", workExperience: [workExperience, workExperience])
        
        // when
        vc.showData(profile)
    
        // then
        XCTAssertEqual(label.text, "blah")
        XCTAssertEqual(vc.tableView(vc.tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(vc.tableView(vc.tableView, numberOfRowsInSection: 1), 2)
    }
}
