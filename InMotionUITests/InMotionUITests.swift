//
//  InMotionUITests.swift
//  InMotionUITests
//
//  Created by iosdev on 14.4.2021.
//

import XCTest

class InMotionUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginButtonVisibility1() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let loginButton = app.buttons["Login"]
        XCTAssert(!loginButton.isEnabled, "Login button is visible")
    }
    
//    func testLoginButtonVisibility2() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        let usernameField = app.textFields["Username"]
//        usernameField.tap()
//        usernameField.typeText("username")
//
//        let passwordSecureTextField = app.secureTextFields["Password"]
//        passwordSecureTextField.tap()
//        passwordSecureTextField.typeText("P4ssw0rd")
//
//        let loginButton = app.buttons["Login"]
//        XCTAssert(loginButton.isEnabled, "Login button is not visible")
//    }
    
    func testRegisterButtonVisibility1() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let toRegisterButton = app.buttons["Don't have an account yet? Register here"]
        toRegisterButton.tap()
        
        let registerButton = app.buttons["Register"]
        XCTAssert(!registerButton.isEnabled, "Register button is not visible")
    }
    
//    func testRegisterButtonVisibility2() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//        
//        let toRegisterButton = app.buttons["Don't have an account yet? Register here"]
//        toRegisterButton.tap()
//        
//        let usernameField = app.textFields["Username"]
//        usernameField.tap()
//        usernameField.typeText("username")
//        
//        let pwField = app.secureTextFields["Password"]
//        pwField.tap()
//        pwField.typeText("P4ssw0rd")
//        
//        let cpwField = app.secureTextFields["Confirm Password"]
//        cpwField.tap()
//        cpwField.typeText("P4ssw0rd")
//        
//        let registerButton = app.buttons["Register"]
//        XCTAssert(registerButton.isEnabled, "Register button is not visible")
//    }
    
    
}
