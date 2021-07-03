//
//  CustomAnnotation.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

import UIKit
import MapKit

class CustomAnnotation2: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageOfCountry: String?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.imageOfCountry = nil
    }
}
