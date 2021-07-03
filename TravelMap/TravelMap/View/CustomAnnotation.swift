//
//  CustomAnnotation.swift
//  TravelMap
//
//  Created by Даниил Петров on 03.07.2021.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(
        coordinate: CLLocationCoordinate2D,
        title: String?,
        subtitle: String?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
//    var subtitle: String? {
//        return locationName
//    }
}
