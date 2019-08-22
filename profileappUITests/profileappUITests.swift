//
//  profileappUITests.swift
//  profileappUITests
//
//  Created by Mirek Petricek on 21/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import XCTest

class profileappUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func testHappyPath() {
        //given
        configureHappyPath()
        
        //when
        app.launch()
        
        //then
        XCTAssertTrue(XCUIApplication().staticTexts["John Appleseed"].exists)
        XCTAssertTrue(XCUIApplication().staticTexts["Client1"].exists)
        XCTAssertTrue(XCUIApplication().staticTexts["Client2"].exists)
    }
    
    private func configureHappyPath() {
        app.launchEnvironment["getProfile-reply"] = validResponse
    }
    
    private var validResponse: String? {
        let fileName = "valid-profile"
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            XCTFail("Unable to load \(fileName).json")
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data.base64EncodedString()
        } catch {
            // fallback to test failure
            XCTFail("Unable to load \(fileName).json")
        }
        return nil
    }
}
