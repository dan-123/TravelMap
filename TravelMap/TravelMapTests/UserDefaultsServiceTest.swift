//
//  UserDefaultsServiceTest.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 26.07.2021.
//

import XCTest

// MARK: -  Description

/// Проверка сервиса на корректность сохранения данных в userDefaults по ключу

class UserDefaultsServiceTest: XCTestCase {
    
    let userDefaultsTest = UserDefaultsService()
    
    //MARK: - Test that service correctly saves data by key
    
    func testThatServiceCorrectlySavesDataByKey() {
        //arrange
        let key = "Test key"
        let string = "Test value"
        let expectedString = "Test value"
        
        //act
        userDefaultsTest.saveData(object: string, key: key)
        let result: String? = userDefaultsTest.getData(key: key)
        
        //assert
        XCTAssertEqual(result, expectedString)
    }
}
