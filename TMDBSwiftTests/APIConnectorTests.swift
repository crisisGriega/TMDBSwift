//
//  APIConnectorTests.swift
//  TMDBSwiftTests
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import XCTest
@testable import TMDBSwift

import Alamofire


class APIConnectorTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDiscoverMovies() {
        self.commonTestingApiURLFor(.discover, resource: .movie);
    }
    
    func testSimpleImage() {
        let expectation = self.expectation(description: "expectation-api-image");
        
        let url = TMDBAPIConnector.default.urlForImagewithPath("xGWVjewoXnJhvxKW619cMzppJDQ.jpg");
        Alamofire.request(url).responseData { response in
            XCTAssert(response.result.isSuccess);
            expectation.fulfill();
        }
        
        waitForExpectations(timeout: 120.0) { (error) in }
    }
}


private extension APIConnectorTests {
    func commonTestingApiURLFor(_ operation: APIOperation, resource: TMDBEntityType) {
        let expectation = self.expectation(description: "expectation-api-\(operation)-for-\(resource)");
        
        let url = TMDBAPIConnector.default.urlFor(operation, resource: resource);
        Alamofire.request(url).responseJSON { response in
            XCTAssertTrue(response.result.isSuccess);
            expectation.fulfill();
        }
        
        waitForExpectations(timeout: 120.0) { (error) in }
    }
}
