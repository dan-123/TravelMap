//
//  PhotoCountUITest.swift
//  TravelMapUITests
//
//  Created by Даниил Петров on 29.07.2021.
//

import XCTest

// MARK: - Description

/// Проверка настройки количества загружаемых фото по следующему кейсу:
/// Если ввести значение больше 20, то появляется соответсвующее предупреждение

class PhotoCountUITest: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }
    
    // MARK: - Test that when enter large value an alert appears
    
    func testThatWhenEnterLargeValueAnAlertAppears() {
        setPhotoCount(firstKey: "5", secondKey: "0")
    }
}
