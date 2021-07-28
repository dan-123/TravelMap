//
//  ImageLoaderServiceTests.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 28.07.2021.
//

import XCTest
import UIKit

class ImageLoaderServiceTests: XCTestCase {

    // MARK: -  Description

    /// Проверка сервиса загрузки картинок для страны по следующим кейсам:
    /// 1. Сервис возвращает массив с корректным числом картинок.
    /// 2. Некорректные данные от сервера.
    
    // MARK: - Test that service returns array with correct number of images
    
    func testThatServiceReturnsArrayWithCorrectNumberOfImages() {
        //arrange
        let countryImageModel = CountryImageModel(photos: [.init(src: .init(medium: "1")),
                                                           .init(src: .init(medium: "2")),
                                                           .init(src: .init(medium: "3"))])
        let imageResult = [UIImage(systemName: "photo")!,
                           UIImage(systemName: "photo")!,
                           UIImage(systemName: "photo")!]
        
        let networkServiceTest = ImageNetworkServiceClass(countryImageModel: countryImageModel, imageResult: imageResult, networkCompletion: .success)

        let imageLoaderService = ImageLoaderService(networkService: networkServiceTest)
        let expectation = expectation(description: "Success and network error")
        let expectationCount = imageResult.count
        
        //act
        imageLoaderService.loadImage(country: "Test") { result in
            switch result {
            case .success(let data):
                //assert
                XCTAssertEqual(expectationCount, data.count)
                expectation.fulfill()
            case .failure(_):
                break
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    // MARK: - Test that function returns error if received network error from service
    
    func testThatFunctionReturnsErrorIfReceivedNetworkErrorFromService() {
        //arrange
        let countryImageModel = CountryImageModel(photos: [])
        let imageResult = [UIImage]()
        
        let networkServiceTest = ImageNetworkServiceClass(countryImageModel: countryImageModel, imageResult: imageResult, networkCompletion: .failure)

        let imageLoaderService = ImageLoaderService(networkService: networkServiceTest)
        
        let expectation = expectation(description: "Failure and network error")
        let expectedError = NetworkServiceError.network
        
        //act
        imageLoaderService.loadImage(country: "Test") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                //assert
                XCTAssertTrue(error.localizedDescription == expectedError.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
}
