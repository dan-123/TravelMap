//
//  City+CoreDataProperties.swift
//  TravelMap
//
//  Created by Даниил Петров on 17.07.2021.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var city: String
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var countryCode: String
    @NSManaged public var cityId: String

}

extension City : Identifiable {

}
