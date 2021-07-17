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
    // добавить функции в протокол
    
}

class CoreDataService {
    private let coreDataStack = CoreDataStack.shared
    
    //    private lazy var frc
    
}

// MARK: - Country

extension CoreDataService: CoreDataServiceProtocol {
    
    //добавление страны
    func addCountry(country: [CountryDTO]) -> Bool {
        var result = false
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            country.forEach {
                if ((try? self.fetchRequestForCountry(for: $0).execute().first) != nil) {
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
    
    // получение данных
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
    
    // удаление страны
    func deleteCountry(country: [CountryDTO]?) {
        guard let country = country else {
            deleteAllForCountry()
            return
        }
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            country.forEach {
                if let country = try? self.fetchRequestForCountry(for: $0).execute().first {
                    context.delete(country)
                }
            }
            try? context.save()
        }
    }
}
    
// MARK: - City

extension CoreDataService {
    
    //добавление города
    func addCity(city: [CityDTO]) -> Bool {
        var result = false
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            city.forEach {
                if ((try? self.fetchRequestForCity(for: $0).execute().first) != nil) {
                    print("такой город есть")
                    result = true
                } else {
                    let city = City(context: context)
                    city.cityId = $0.cityId
                    city.countryCode = $0.countryCode
                    city.city = $0.city
                    city.latitude = $0.latitude
                    city.longitude = $0.longitude
                    print("add to core data")
                }
            }
        try? context.save()
        }
        return result
    }
    
    // получение городов
    func getCityData(predicate: String?) -> [CityDTO]? {
        print("show core data 1")
        let context = coreDataStack.viewContext
        var result = [CityDTO]()
        
        let request = NSFetchRequest<City>(entityName: "City")
        if let predicate = predicate {
            request.predicate = .init(format: "countryCode == %@", predicate)
        }
        
        context.performAndWait {
            guard let city = try? request.execute() else { return }
            result = city.map { CityDTO(with: $0) }
        }
        print("добавленные города: \(result)")
        return result
    }
    
    // удаление городов
    func deleteCity(city: [CityDTO]?) {
        guard let city = city else {
            deleteAllForCity()
            return
        }
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            city.forEach {
                if let city = try? self.fetchRequestForCity(for: $0).execute().first {
                    context.delete(city)
                }
            }
            try? context.save()
        }
    }
}
    

// MARK: - Delete all element for Country DTO

private extension CoreDataService {
    private func deleteAllForCountry() {
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
// MARK: - Delete all element for City DTO

private extension CoreDataService {
    private func deleteAllForCity() {
        let context = coreDataStack.backgroundContext
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        context.performAndWait {
            let countries = try? fetchRequest.execute()
            countries?.forEach {
                context.delete($0)
            }
            try? context.save()
        }
    }
}

// MARK: - Fetch request for Country DTO

private extension CoreDataService {
    private func fetchRequestForCountry(for dto: CountryDTO) -> NSFetchRequest<Country> {
        let request = NSFetchRequest<Country>(entityName: "Country")
        request.predicate = .init(format: "countryCode == %@", dto.countryCode)
        return request
    }
}

// MARK: - Fetch request for City DTO

private extension CoreDataService {
    private func fetchRequestForCity(for dto: CityDTO) -> NSFetchRequest<City> {
        let request = NSFetchRequest<City>(entityName: "City")
        request.predicate = .init(format: "cityId == %@", dto.cityId)
        return request
    }
}

// MARK: - Init for Country DTO

fileprivate extension CountryDTO {
    init(with MO: Country) {
        self.countryCode = MO.countryCode
        self.country = MO.country
        self.latitude = MO.latitude
        self.longitude = MO.longitude
        self.border = MO.border
    }
}

// MARK: - Init for City DTO

fileprivate extension CityDTO {
    init(with MO: City) {
        self.cityId = MO.cityId
        self.countryCode = MO.countryCode
        self.city = MO.city
        self.latitude = MO.latitude
        self.longitude = MO.longitude
    }
}
