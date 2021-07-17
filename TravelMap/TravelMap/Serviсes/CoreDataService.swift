//
//  CoreDataService.swift
//  TravelMap
//
//  Created by Даниил Петров on 16.07.2021.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func addCountry(country: [CountryDTO]) -> Bool
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
    
//    //добавление (добавить проверку страны)
//    func addCountry(countryDTO: CountryDTO) {
//        let context = coreDataStack.backgroundContext
//        context.performAndWait {
//            let country = Country(context: context)
//            country.countryCode = countryDTO.countryCode
//            country.country = countryDTO.country
//            country.latitude = countryDTO.latitude
//            country.longitude = countryDTO.longitude
//            country.border = countryDTO.border
//            print("add to core data")
//        }
//        try? context.save()
//    }
    
    //добавление страны
    func addCountry(country: [CountryDTO]) -> Bool {
        var result = false
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            country.forEach {
                if ((try? self.fetchRequest(for: $0).execute().first) != nil) {
                    print("такая страна есть")
                    result = true
                } else {
                    let country = Country(context: context)
                    country.countryCode = $0.countryCode
                    country.country = $0.country
                    country.latitude = $0.latitude
                    country.longitude = $0.longitude
                    country.border = $0.border
                    print("add to core data")
                }
            }
        try? context.save()
        }
        return result
    }
    
    // добавленные страны
    func getCountryData(predicate: String?) -> [CountryDTO]? {
        print("show core data 1")
        let context = coreDataStack.viewContext
        var result = [CountryDTO]()
        
        let request = NSFetchRequest<Country>(entityName: "Country")
        if let predicate = predicate {
            request.predicate = .init(format: "countryCode == %@", predicate)
        }
        
        context.performAndWait {
            guard let country = try? request.execute() else { return }
            result = country.map { CountryDTO(with: $0) }
        }
        print("добавленные страны: \(result)")
        return result
    }
    
    // удаление выбранной страны
    func delete(country: [CountryDTO]?) {
        guard let country = country else {
            deleteAll()
            return
        }
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            country.forEach {
                if let country = try? self.fetchRequest(for: $0).execute().first {
                    context.delete(country)
                }
            }
            try? context.save()
        }
    }
    
    // удаление всех элементов
    private func deleteAll() {
        let context = coreDataStack.backgroundContext
        let fetchRequest = NSFetchRequest<Country>(entityName: "Country")
        context.performAndWait {
            let countries = try? fetchRequest.execute()
            countries?.forEach {
                context.delete($0)
            }
            try? context.save()
        }
    }
    
    
}

private extension CoreDataService {
    private func fetchRequest(for dto: CountryDTO) -> NSFetchRequest<Country> {
        let request = NSFetchRequest<Country>(entityName: "Country")
        request.predicate = .init(format: "countryCode == %@", dto.countryCode)
        return request
    }

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
