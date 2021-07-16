//
//  CoreDataService.swift
//  TravelMap
//
//  Created by Даниил Петров on 16.07.2021.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func addCountry(_ countryCodeName: String, _ countryName: String, _ latitudeValue: Double, _ longitudeValue: Double, borderValue: [Double])
    //    func deleteCountry(_ countryCode: String)
    
    //    func addCity()
    //    func deleteCity()
    
}

class CoreDataService {
    private let coreDataStack = CoreDataStack.shared
    
    //    private lazy var frc
    
}

// MARK: - Extension

extension CoreDataService: CoreDataServiceProtocol {
    func addCountry(_ countryCodeName: String, _ countryName: String, _ latitudeValue: Double, _ longitudeValue: Double, borderValue: [Double]) {
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            let country = Country(context: context)
            country.countryCode = countryCodeName
            country.country = countryName
            country.latitude = latitudeValue
            country.longitude = longitudeValue
            country.border = borderValue
            print("add to core data")
        }
        try? coreDataStack.backgroundContext.save()
    }
    
    func showCountryData() {
        print("show core data 1")
        let context = coreDataStack.viewContext
        var result = [CountryDTO]()
        
        let request = NSFetchRequest<Country>(entityName: "Country")
        request.predicate = .init(format: "countryCode == %@", "it")
        
        context.performAndWait {
            guard let country = try? request.execute() else { return }
            result = country.map { CountryDTO(with: $0) }
        }
        print(result)
    }
    
    
    //    func deleteCountry(_ countryCode: String) {
    //
    //    }
    
    
}

fileprivate extension CountryDTO {
    init(with MO: Country) {
        self.countryCode = MO.countryCode
        self.country = MO.country
        self.latitude = MO.latitude
        self.longitude = MO.longitude
        self.border = MO.border
    }
}
