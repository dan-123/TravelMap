//
//  TravelMapUITests.swift
//  TravelMapUITests
//
//  Created by Даниил Петров on 07.07.2021.
//

import XCTest

class TravelMapUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    
    func testLaunchController() {
        XCTAssertTrue(app.staticTexts["Настройки пользователя"].exists)
    }
    
    func testChangeController() {
        app.tabBars["Tab Bar"].buttons["Bookmarks"].tap()
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["тест"].tap()
        XCTAssertTrue(app.staticTexts["тест 0"].exists)
    }

    
}

