//
//  Constants.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

enum Constants {
    static let apiKey = "f462acbf8d194c0aa37339c5d6b6ec83"
    
    enum CountryCoordinate {
        static let type = "country"
        static let getContryCoordinate = "https://api.geoapify.com/v1/geocode/search?"
    }
    
    enum InitialCoordinate {
        static let latitude = 55.453699
        static let longitude = 72.597645
        static let latitudeDelta = 86.854243
        static let longitudeDelta = 112.499994
    }
}
