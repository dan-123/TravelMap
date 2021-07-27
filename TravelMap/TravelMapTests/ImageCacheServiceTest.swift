//
//  ImageCacheServiceTest.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 27.07.2021.
//

import XCTest
import UIKit

// MARK: -  Description

/// Проверка сервиса на корректность сохранения картинок в NSCache по ключу

class ImageCacheServiceTest: XCTestCase {
    
    // MARK: - Test that service correctly saves images by key
    
    let imageCacheServiceTest: ImageCacheService = .shared
    
    func testThatServiceCorrectlySavesImagesByKey() {
        //arrange
        let key = "Test key"
        let image = UIImage(systemName: "photo")!
        let expectedImage = UIImage(systemName: "photo")!
        
        //act
        imageCacheServiceTest.saveImage(image: image, key: key)
        let result = imageCacheServiceTest.getImage(key: key)
        
        //assert
        XCTAssertEqual(result, expectedImage)
    }
}
