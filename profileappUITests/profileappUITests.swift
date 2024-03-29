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
        XCTAssertTrue(XCUIApplication().staticTexts["Role1"].exists)
        XCTAssertTrue(XCUIApplication().staticTexts["Location1"].exists)
        XCTAssertTrue(XCUIApplication().staticTexts["Jan 2019 - Jul 2019"].exists)
    }
    
    func testErrorPath() {
        //given
        configureErrorPath()
        
        //when
        app.launch()
        
        //then
        XCTAssertTrue(XCUIApplication().alerts["Something went wrong"].exists)
    }
    
    private func configureHappyPath() {
        app.launchEnvironment["getProfile-reply"] = validResponse
    }
    
    private func configureErrorPath() {
        app.launchEnvironment["getProfile-reply"] = "{ This is a deliberately malformed json data }".data(using: .utf8)?.base64EncodedString()
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
