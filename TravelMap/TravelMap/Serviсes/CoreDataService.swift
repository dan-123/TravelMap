//
//  CoreDataService.swift
//  TravelMap
//
//  Created by Даниил Петров on 16.07.2021.
//

import Foundation
import CoreData

// MARK: - Protocol

protocol CoreDataServiceCountryProtocol {
    //добавление новой страны (возвращает true если такая страна уже есть)
    func addCountry(country: [CountryDTO]) -> Bool
    // получение информации о стране
    func getCountryData(predicate: String?) -> [CountryDTO]?
    // удаление страны
    func deleteCountry(country: [CountryDTO]?)
}

protocol CoreDataSerivceCountryDelegate: AnyObject {
    func reloadData()
}

protocol CoreDataServiceCityProtocol {
    //добавление города (возвращает true если такой город уже есть)
    func addCity(city: [CityDTO]) -> Bool
    // получение инофрмации о городах
    func getCityData(predicate: String?) -> [CityDTO]?
    // удаление города
    func deleteCity(city: [CityDTO]?)
}

// MARK: - Core data serivce

class CoreDataService: NSObject {
    
    // MARK: Properties
    weak var delegate: CoreDataSerivceCountryDelegate?
    
    private let coreDataStack = CoreDataStack.shared
    
    lazy var frcCountry: NSFetchedResultsController<Country> = {
       let request = NSFetchRequest<Country>(entityName: "Country")
        request.sortDescriptors = [.init(key: "country", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: coreDataStack.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    // MARK: Methods
    func GetFrcForCity(predicate: String) -> NSFetchedResultsController<City> {
        let request = NSFetchRequest<City>(entityName: "City")
        request.predicate = .init(format: "countryCode == %@", predicate)
        request.sortDescriptors = [.init(key: "city", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: coreDataStack.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return frc
    }
    
}

// MARK: - Extensions for Country

//MARK: extension (CoreDataServiceCountryProtocol)

extension CoreDataService: CoreDataServiceCountryProtocol {
    
    func addCountry(country: [CountryDTO]) -> Bool {
        var result = false
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            country.forEach {
                if ((try? self.fetchRequestForCountry(for: $0).execute().first) != nil) {
                    result = true
                } else {
                    let country = Country(context: context)
                    country.countryCode = $0.countryCode
                    country.country = $0.country
                    country.latitude = $0.latitude
                    country.longitude = $0.longitude
                    country.border = $0.border
                }
            }
        try? context.save()
        }
        return result
    }
    
    func getCountryData(predicate: String?) -> [CountryDTO]? {
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
        return result
    }
    
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

// MARK: extension (Delete all element from Country)

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

// MARK: extension (Fetch request for Country)

private extension CoreDataService {
    private func fetchRequestForCountry(for dto: CountryDTO) -> NSFetchRequest<Country> {
        let request = NSFetchRequest<Country>(entityName: "Country")
        request.predicate = .init(format: "countryCode == %@", dto.countryCode)
        return request
    }
}

// MARK: extension (Init Country DTO)

fileprivate extension CountryDTO {
    init(with MO: Country) {
        self.countryCode = MO.countryCode
        self.country = MO.country
        self.latitude = MO.latitude
        self.longitude = MO.longitude
        self.border = MO.border
    }
}

// MARK: extension (NSFetchedResultsControllerDelegate)

extension CoreDataService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
    }
    
}

// MARK: - Extensions for City

// MARK: Extensions (CoreDataServiceCityProtocol)

extension CoreDataService: CoreDataServiceCityProtocol {
    
    func addCity(city: [CityDTO]) -> Bool {
        var result = false
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            city.forEach {
                if ((try? self.fetchRequestForCity(for: $0).execute().first) != nil) {
                    result = true
                } else {
                    let city = City(context: context)
                    city.cityId = $0.cityId
                    city.countryCode = $0.countryCode
                    city.city = $0.city
                    city.latitude = $0.latitude
                    city.longitude = $0.longitude
                }
            }
        try? context.save()
        }
        return result
    }
    
    func getCityData(predicate: String?) -> [CityDTO]? {
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
        return result
    }
    
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
    
// MARK: extension (Delete all element from City)

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

// MARK: extension (Fetch request for City)

private extension CoreDataService {
    private func fetchRequestForCity(for dto: CityDTO) -> NSFetchRequest<City> {
        let request = NSFetchRequest<City>(entityName: "City")
        request.predicate = .init(format: "cityId == %@", dto.cityId)
        return request
    }
}

// MARK: extension (Init City DTO)

fileprivate extension CityDTO {
    init(with MO: City) {
        self.cityId = MO.cityId
        self.countryCode = MO.countryCode
        self.city = MO.city
        self.latitude = MO.latitude
        self.longitude = MO.longitude
    }
}
