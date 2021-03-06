//
//  UserDefaultsServiceTest.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 26.07.2021.
//

import XCTest

// MARK: -  Description

/// Проверка сервиса на корректность сохранения данных в userDefaults.

class UserDefaultsServiceTest: XCTestCase {
    
    let userDefaultsTest = UserDefaultsService()
    
    //MARK: - Test that the data is stored correctly in the user defaults
    
    func testThatDataIsStoredСorrectlyInTheUserDefaults() {
        //arrange
        let string = "Test value"
        let key = "Test string"
        
        //act
        userDefaultsTest.saveData(object: string, key: key)
        let expectedString: String? = userDefaultsTest.getData(key: key)
        
        //assert
        XCTAssertEqual(string, expectedString)
    }
}
