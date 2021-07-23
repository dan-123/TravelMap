//
//  MapViewControllerTest.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 22.07.2021.
//

import XCTest

// MARK: - Network service

class CoordinateNetworkService: CoordinateNetworkServiceProtocol {
    
    let coordinateModel: CoordinateModel
    
    init(coordinateModel: CoordinateModel) {
        self.coordinateModel = coordinateModel
    }
    
    func getCoordinate(placeType: String, placeName: String, countryCode: String?, completion: @escaping (GetCountryCoordinateResponce) -> Void) {
        completion(.success(coordinateModel))
    }
}

// MARK: - City core data service

class CountryCoreDataService: CoreDataServiceCountryProtocol & CoreDataServiceCityProtocol {
    func addCountry(country: [CountryDTO]) -> Bool {
        return false
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
    
    
    // MARK: - Test that function return country code
    
    func testThatFunctionReturnCountryCode() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [.init(properties: .init(city: nil, country: "Italy", countryCode: "it", lon: 12.674297, lat: 42.6384261, placeId: "51f294d5743d59294059d7344af2b7514540f00101f9011393050000000000c0020b"), bbox: [6.6272658, 35.2889616, 18.7844746, 47.0921462])])
        
        let coordinateNetworkService = CoordinateNetworkService(coordinateModel: coordinateModel)
        let countryCoreDataService = CountryCoreDataService()
        
        let mapViewController = MapViewController(networkService: coordinateNetworkService,
                                                  coreDataService: countryCoreDataService)
        
        //act
        mapViewController.loadCountryCoordinate(country: "Test")
        
        //assert
        XCTAssertNotNil(mapViewController.countryCode, "Country code is not nil")
    }
    
    // MARK: - Test that function return error if there is no data
    
    func testThatFunctionReturnErrorIfThereIsNoData() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [])
        
        let coordinateNetworkService = CoordinateNetworkService(coordinateModel: coordinateModel)
        let countryCoreDataService = CountryCoreDataService()
        
        let mapViewController = MapViewController(networkService: coordinateNetworkService,
                                                  coreDataService: countryCoreDataService)
        
        let expectedError = NetworkServiceError.country
        var isEqual: Bool = false

        //act
        mapViewController.loadCountryCoordinate(country: "Test")
        mapViewController.showAlert = { error in
            isEqual = error.localizedDescription == expectedError.localizedDescription
        }
        
        //assert
        XCTAssertTrue(isEqual)
    }

}
