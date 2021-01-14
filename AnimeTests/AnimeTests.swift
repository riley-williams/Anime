//
//  AnimeTests.swift
//  AnimeTests
//
//  Created by Riley Williams on 1/13/21.
//

import XCTest
@testable import Anime

class AnimeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testISOStringToDateExtension() throws {
        let string = "2013-04-07T00:00:00+00:00"
		
		if let date = string.toDateISO() {
			XCTAssertEqual("2013", date.year)
		} else {
			XCTFail("Failed to decode date")
		}
	
		
    }


}
