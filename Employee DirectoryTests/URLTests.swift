//
//  URLTests.swift
//  Employee DirectoryTests
//
//  Created by Brian Papa on 6/4/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import XCTest
@testable import Employee_Directory

class URLTests: XCTestCase {

    func testCachedFileURLDistinctURLsCreatesDistinctCachedFileURLs() {
        let firstURL = URL(string: "http://squareup.com")
        let secondURL = URL(string: "http://apple.com")
        XCTAssertNotEqual(firstURL?.cachedFileURL, secondURL?.cachedFileURL)
    }
    
    func testCachedFileURLSameURLsCreatesConsistentCachedFileURLs() {
        let urlString = "http://squareup.com"
        let firstURL = URL(string: urlString)
        let secondURL = URL(string: urlString)
        XCTAssertEqual(firstURL?.cachedFileURL, secondURL?.cachedFileURL)
    }

}
