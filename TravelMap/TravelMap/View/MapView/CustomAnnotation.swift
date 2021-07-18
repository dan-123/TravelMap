//
//  CustomAnnotation.swift
//  TravelMap
//
//  Created by Даниил Петров on 03.07.2021.
//

import MapKit

enum AnnotationType {
    case global
    case local
}

class CustomAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let countryCode: String?
    let placeId: String?
    let annotationType: AnnotationType
    
    // свойство для первого варианта из CustomAnnotationVew
    var annotationTintColor: UIColor   {
        switch annotationType {
        case .global:
            return .systemBlue
        case .local:
            return .systemGreen
        }
    }
    
    var image: UIImage {
        switch annotationType {
        case .global:
            return UIImage(named: "globalAnnotation") ?? UIImage()
        case .local:
            return UIImage(named: "localAnnotation") ?? UIImage()
        }
    }
    
    // MARK: - Init
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, countryCode: String?, placeId: String?, annotationType: AnnotationType) {
        self.title = title
        self.subtitle = subtitle
        self.countryCode = countryCode
        self.coordinate = coordinate
        self.placeId = placeId
        self.annotationType = annotationType
        super.init()
    }
}
