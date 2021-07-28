//
//  ExtensionXCUIApplication.swift
//  TravelMapUITests
//
//  Created by Даниил Петров on 29.07.2021.
//

import XCTest

extension XCUIApplication {
    func tabBarElement() -> XCUIElement {
        return self.tabBars.buttons["Настройки"]
    }
    
    func photoCountTextField() -> XCUIElement {
        return self.tables.cells.containing(.staticText, identifier:"Количество отображаемых фото").children(matching: .textField).element
    }
    
    func deleteKey() -> XCUIElement {
        return keyboards.keys["Delete"]
    }
    
    func numberKey(key: String) -> XCUIElement {
        return keyboards.keys[key]
    }
    
    func tableElement() -> XCUIElement {
        return self.tables.cells.staticTexts["О приложении"]
    }
    
    func buttonOk() -> XCUIElement {
        return alerts["Предупреждение"].scrollViews.otherElements.buttons["ОК"]
    }
}
