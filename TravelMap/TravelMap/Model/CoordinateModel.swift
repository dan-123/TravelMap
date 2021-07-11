//
//  CoordinateModel.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

import Foundation

struct CoordinateModel: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let properties: Properties
    let bbox: [Double]
}

struct Properties: Codable {
    let city: String?
    let country: String
    let countryCode: String
    let lon: Double
    let lat: Double
    let placeId: String
}
