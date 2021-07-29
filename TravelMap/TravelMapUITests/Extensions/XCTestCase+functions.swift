//
//  XCTestCase+functions.swift
//  TravelMapUITests
//
//  Created by Даниил Петров on 29.07.2021.
//

import XCTest

extension XCTestCase {
    
    func choiceScreen() {
        let tabBarElement = XCUIApplication().tabBarElement()
        tabBarElement.tap()
    }
    
    func tapPhotoCountTextField() {
        let photoCountTextField = XCUIApplication().photoCountTextField()
        photoCountTextField.tap()
    }
    
    func deleteFromPhotoCountTextField() {
        let deleteKey = XCUIApplication().deleteKey()
        deleteKey.tap()
    }
    
    func InputIntoPhotoCountTextField(key: String) {
        let firstKey = XCUIApplication().numberKey(key: key)
        firstKey.tap()
    }
    
    func hideKeybord() {
        let tableCell = XCUIApplication().tableElement()
        tableCell.tap()
    }
    
    func clickButtonOk() {
        XCUIApplication().buttonOk().tap()
    }
    
    func setPhotoCount(firstKey: String, secondKey: String) {
        choiceScreen()
        tapPhotoCountTextField()
        deleteFromPhotoCountTextField()
        deleteFromPhotoCountTextField()
        InputIntoPhotoCountTextField(key: firstKey)
        InputIntoPhotoCountTextField(key: secondKey)
        hideKeybord()
        clickButtonOk()
    }
}
