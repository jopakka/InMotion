//
//  DateHelperTests.swift
//  InMotionTests
//
//  Created by iosdev on 3.5.2021.
//

import XCTest
@testable import InMotion

class DateHelperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMillisecondsToDate() throws {
        let milliseconds: Int64 = 190298450000
        let conventer = DateHelper.instance
        let date = conventer.timeStampToDate(milliseconds)
        let correctDate = Date(timeIntervalSince1970: 190298450)
        
        XCTAssert(date == correctDate, "Date is not correct")
    }
}
