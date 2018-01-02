//
//  DataProviderTests.swift
//  TMDBSwiftTests
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import XCTest
@testable import TMDBSwift


class DataProviderTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDiscoverMovies() {
        let expectation = self.expectation(description: "expectation-data-provider-discover");
        
        DataProvider.default.discover(page: 1) { (result) in
            XCTAssert(result.isSuccess);
            expectation.fulfill();
        }
        
        waitForExpectations(timeout: 120.0) { (error) in }
    }
    
    func testDiscoverMoviesParsing() {
        let expectation = self.expectation(description: "expectation-data-provider-discover-parsing");
        
        DataProvider.default.discover(page: 1) { (result) in
            XCTAssert(result.value?.first?.title != nil);
            XCTAssert(result.value?.first?.year != nil);
            XCTAssert(result.value?.first?.posterPath != nil);
            expectation.fulfill();
        }
        
        waitForExpectations(timeout: 120.0) { (error) in }
    }
    
    func testSearch() {
        let expectation = self.expectation(description: "expectation-data-provider-search");
        DataProvider.default.search("it") { (result) in
            XCTAssert(result.value?.first?.title != nil);
            expectation.fulfill();
        }
        
        waitForExpectations(timeout: 120.0) { (error) in }
    }
}
