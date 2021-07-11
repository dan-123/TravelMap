//
//  Constants.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

enum Constants {
    static let apiKey = "f462acbf8d194c0aa37339c5d6b6ec83"
    
    enum Coordinate {
        static let cityCoordinate = "city"
        static let countryCoordinte = "country"
        static let getContryCoordinate = "https://api.geoapify.com/v1/geocode/search?"
        static let getAnnotationCoordinate = "https://api.geoapify.com/v1/geocode/reverse?"
        static let limit = 1
    }
    
    enum InitialCoordinate {
        static let latitude = 55.453699
        static let longitude = 72.597645
        static let latitudeDelta = 86.854243
        static let longitudeDelta = 112.499994
    }
}
