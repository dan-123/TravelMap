//
//  CoreDataServiceTest.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 27.07.2021.
//

// MARK: - Core data service

class CoreDataServiceClass: CoreDataServiceCountryProtocol & CoreDataServiceCityProtocol {
    
    let countryIsAdded: Bool
    let cityIsAdded: Bool
    
    init(countryIsAdded: Bool, cityIsAdded: Bool) {
        self.countryIsAdded = countryIsAdded
        self.cityIsAdded = cityIsAdded
    }
    
    func addCountry(country: [CountryDTO]) -> Bool {
        return countryIsAdded
    }
    
    func getCountryData(predicate: String?) -> [CountryDTO]? {
        return []
    }
    
    func deleteCountry(country: [CountryDTO]?) {
        
    }
    
    func addCity(city: [CityDTO]) -> Bool {
        return cityIsAdded
    }
    
    func getCityData(predicate: String?) -> [CityDTO]? {
        return []
    }
    
    func deleteCity(city: [CityDTO]?) {
    }   
}
