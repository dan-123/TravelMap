//
//  AnnotationModel.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

import Foundation

struct AnnotationModel {
    var countryName: String?
    var countryLatitude: Double?
    var countryLongitude: Double?
    var countryTitle: String?
//    var countryImage
//    var countryPolygon
    var countryAnnotation: [CountryAnnotation]?
}

struct CountryAnnotation {
    var latitude: Float?
    var longitude: Float?
    var title: String?
    var subtitle: String?
}
