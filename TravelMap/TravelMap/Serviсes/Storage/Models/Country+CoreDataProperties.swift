//
//  Country+CoreDataProperties.swift
//  TravelMap
//
//  Created by Даниил Петров on 16.07.2021.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var countryCode: String
    @NSManaged public var country: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var border: [Double]

}

extension Country : Identifiable {

}
