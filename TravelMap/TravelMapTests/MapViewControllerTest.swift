//
//  MapViewControllerTest.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 22.07.2021.
//

import XCTest

// MARK: - Network service

class CoordinateNetworkService: CoordinateNetworkServiceProtocol {
    
    let coordinateModel = CoordinateModel.init(features: [])
    
    func getCoordinate(placeType: String, placeName: String, countryCode: String?, completion: @escaping (GetCountryCoordinateResponce) -> Void) {
        completion(.success(coordinateModel))
    }
}

// MARK: - City core data service

class CountryCoreDataService: CoreDataServiceCountryProtocol & CoreDataServiceCityProtocol {
    func addCountry(country: [CountryDTO]) -> Bool {
        return true
    }
    
    func getCountryData(predicate: String?) -> [CountryDTO]? {
        return []
    }
    
    func deleteCountry(country: [CountryDTO]?) {
        
    }
    
    func addCity(city: [CityDTO]) -> Bool {
        return true
    }
    
    func getCityData(predicate: String?) -> [CityDTO]? {
        return []
    }
    
    func deleteCity(city: [CityDTO]?) {
    }
    
    
}

// MARK: - Map view controller test

class MapViewControllerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let coordinateNetworkService = CoordinateNetworkService()
    let countryCoreDataService = CountryCoreDataService()
    
    lazy var mapViewController: MapViewController = {
        let mapViewController = MapViewController(networkService: coordinateNetworkService,
                                                  coreDataService: countryCoreDataService)
        return mapViewController
    }()
    
    func testThatFunctionReturnsCountryCode() {
        //arrange
        let country = "Italy"
        let countryCode = mapViewController.countryCode
        
        //act
        mapViewController.loadCountryCoordinate(country: country)
        
        //assert
        XCTAssertNil(countryCode, "Country code is nil")
    }

}
