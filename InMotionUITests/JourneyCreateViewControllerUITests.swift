//
//  JourneyCreateViewControllerUITests.swift
//  InMotionUITests
//
//  Created by iosdev on 4.5.2021.
//

import XCTest

class JourneyCreateViewControllerUITests: XCTestCase {
    
    func testRegister() throws {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Don't have an account yet? Register here"]/*[[".buttons[\"Don't have an account yet? Register here\"].staticTexts[\"Don't have an account yet? Register here\"]",".staticTexts[\"Don't have an account yet? Register here\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
       
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("mmmmmmm")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("nnnnnn")
        
        let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("nnnnnn")
        
        let registerStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Register"]/*[[".buttons[\"Register\"].staticTexts[\"Register\"]",".staticTexts[\"Register\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        registerStaticText.tap()
        
        app.tabBars["Tab Bar"].buttons["Journey"].tap()
       
    }
    
    func testJourneyScreen() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["Journey"].tap()
    }
    
    func testStartJourney() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["Journey"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Start Journey"]/*[[".buttons[\"Start Journey\"].staticTexts[\"Start Journey\"]",".staticTexts[\"Start Journey\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testAddPost() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["Journey"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Start Journey"]/*[[".buttons[\"Start Journey\"].staticTexts[\"Start Journey\"]",".staticTexts[\"Start Journey\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["Add memory"].tap()
    }
    
    func testAddContentToPost() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["Journey"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Start Journey"]/*[[".buttons[\"Start Journey\"].staticTexts[\"Start Journey\"]",".staticTexts[\"Start Journey\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add memory"]/*[[".buttons[\"Add memory\"].staticTexts[\"Add memory\"]",".staticTexts[\"Add memory\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let addTitleTextField = elementsQuery.textFields["Add title ..."]
        addTitleTextField.tap()
        let textView = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Notes").children(matching: .textView).element
        textView.tap()
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Upload from file"]/*[[".buttons[\"Upload from file\"].staticTexts[\"Upload from file\"]",".staticTexts[\"Upload from file\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.images["Photo, October 10, 2009, 12:09 AM"].tap()
    }
}

