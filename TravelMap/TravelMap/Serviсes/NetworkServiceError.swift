//
//  NetworkServiceError.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

enum NetworkServiceError: Error {
    case country
    case city
    case repeatCountry
    case repeatCity
    case network
    case unknown
}
