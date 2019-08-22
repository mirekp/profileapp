//
//  NetworkServiceTests.swift
//  profileappTests
//
//  Created by Mirek Petricek on 22/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import XCTest
@testable import profileapp

class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
        
    }
}

class MockURLSession: URLSession {
    var dataTaskArgsForCall = [URL]()
    var dataTaskCompletion: (data: Data?, response: URLResponse?, error: Error?)?
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskArgsForCall.append(url)
        guard let dataTaskCompletion = dataTaskCompletion else {
            assertionFailure()
            return MockURLSessionDataTask()
        }
        completionHandler(dataTaskCompletion.data, dataTaskCompletion.response, dataTaskCompletion.error)
        return MockURLSessionDataTask()
    }
}

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var mockURLSession: MockURLSession!
    
    enum MockError: Error {
        case mockError
    }

    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        networkService = NetworkService(session: mockURLSession)
    }

    override func tearDown() {
        networkService = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testGetProfile_whenNetworkSessionSucceeds_triggersAFailure() {
        //given
        let expectedProfile = Profile(name: "John Appleseed", summary: "sample-summary", workExperience: [Profile.WorkExperience(client: "a client", location: "a location", from: Date(), to: Date(), role: "a role", summary: "a summary")])
        let expectation = XCTestExpectation(description: "getProfileCallbackCalled")
        let expectedResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession.dataTaskCompletion = (data: validJson.data(using: .utf8), response: expectedResponse, error: nil)
        
        //when
        networkService.getProfile { result in
            switch result {
            case .success(let parsedProfile):
                XCTAssertEqual(parsedProfile, expectedProfile)
            default:
                XCTFail("Unexpected failure")
            }
            expectation.fulfill()
        }
        
        //then
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetProfile_whenNonParseableJSON_triggersAFailure() {
        //given
        
        let expectation = XCTestExpectation(description: "getProfileCallbackCalled")
        let expectedResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession.dataTaskCompletion = (data: "not-a-json".data(using: .utf8), response: expectedResponse, error: nil)
        
        //when
        networkService.getProfile { result in
            switch result {
            case .failure(_):
                // all good
                break
            default:
                XCTFail("Unexpected success")
            }
            expectation.fulfill()
        }
        
        //then
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetProfile_whenHTTPError_triggersAFailure() {
        //given
        
        let expectation = XCTestExpectation(description: "getProfileCallbackCalled")
        let expectedResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        mockURLSession.dataTaskCompletion = (data: validJson.data(using: .utf8), response: expectedResponse, error: nil)
        
        //when
        networkService.getProfile { result in
            switch result {
            case .failure(_):
                // all good
                break
            default:
                XCTFail("Unexpected success")
            }
            expectation.fulfill()
        }
        
        //then
        wait(for: [expectation], timeout: 3.0)
    }

    func testGetProfile_whenNetworkSessionFails_triggersAnError() {
        //given
        let expectedError = NetworkService.Errors.networkError(nil)
        let expectation = XCTestExpectation(description: "getProfileCallbackCalled")
        let expectedResponse = URLResponse(url: URL(string: "http://example.com")!, mimeType: "something", expectedContentLength: 0, textEncodingName: nil)
        mockURLSession.dataTaskCompletion = (data: validJson.data(using: .utf8), response: expectedResponse, error: MockError.mockError)
        
        //when
        networkService.getProfile { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
            default:
                XCTFail("Unexpected success")
            }
            expectation.fulfill()
        }
        
        //then
        wait(for: [expectation], timeout: 3.0)
    }
    
    var validJson: String {
        return """
        {
        "name": "John Appleseed",
        "summary": "sample-summary",
        "work_experience" : [
        {
        "client": "a client",
        "location": "a location",
        "date_from": "2017-06-01T18:25:43.511Z",
        "date_to": "2018-12-31T18:25:43.511Z",
        "role": "a role",
        "summary": "a summary"
        }
        ]
        }
        """
    }
}
