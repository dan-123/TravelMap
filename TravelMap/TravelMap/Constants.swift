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
    
    enum Image {
        static let keyword = "query"
        static let totalResult = "1"
        static let perPage = 5
        static let getCountryImageURL = "https://api.pexels.com/v1/search?"
        static let authorization = "563492ad6f917000010000013adcba2f0f0348fe97c6b76cc7b68602"
    }
    
    enum InitialCoordinate {
        static let latitude = 55.453699
        static let longitude = 72.597645
        static let latitudeDelta = 86.854243
        static let longitudeDelta = 112.499994
    }
    
    enum ControllerTitle {
        static let placesTitle = "Страны"
        static let mapTitle = "Карта"
        static let settingTitle = "Настройки"
    }
    
    enum UserDefaultsKey {
        static let keyForPhotoCount = "keyForPhotoCount"
    }
    
    //France
    //countryBorder = [-7.518476, 39.190641, 12.520585, 53.088162]
}
