//
//  CountryImageModel.swift
//  TravelMap
//
//  Created by Даниил Петров on 13.07.2021.
//

import Foundation

struct CountryImageModel: Codable {
    let photos: [Photo]
}
struct Photo: Codable {
    let src: Src
}

struct Src: Codable {
    let medium: String
}
