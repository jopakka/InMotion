//
//  JourneyCreateViewControllerUITests.swift
//  InMotionUITests
//
//  Created by iosdev on 4.5.2021.
//

import XCTest

class MainViewControllerUITests: XCTestCase {
    
    
    func testHomeButton() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Home"].tap()
        XCTAssertEqual(app.navigationBars.element.identifier, "Home")
    }
    
    func testJourneyButton() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Journey"].tap()
        print("RESULT: ", app.navigationBars.element.identifier)
        XCTAssertEqual(app.navigationBars.element.identifier, "Journey")
    }
    
    func testHistoryButton() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["History"].tap()
        print("RESULT: ", app.navigationBars.element.identifier)
        XCTAssertEqual(app.navigationBars.element.identifier, "History")
    }
    
    func testSettingsButton() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Settings"].tap()
        print("RESULT: ", app.navigationBars.element.identifier)
        XCTAssertEqual(app.navigationBars.element.identifier, "Profile")
    }
}

