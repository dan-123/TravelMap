//
//  NetworkServiceError.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

import Foundation

enum NetworkServiceError: LocalizedError {
    case country
    case city
    case repeatCountry
    case repeatCity
    case network
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .country:
            return "country"
        case .city:
            return "city"
        case .repeatCountry:
            return "repeatCountry"
        case .repeatCity:
            return "repeatCity"
        case .network:
            return "network"
        case .unknown:
            return "unknown"
        }
    }
}
