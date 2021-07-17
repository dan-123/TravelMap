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
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let countryCode: String?
    let annotationType: AnnotationType
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, countryCode: String?, annotationType: AnnotationType) {
        self.title = title
        self.subtitle = subtitle
        self.countryCode = countryCode
        self.coordinate = coordinate
        self.annotationType = annotationType
        super.init()
    }
    
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
        #warning("force")
        switch annotationType {
        case .global:
//            return UIImage(systemName: "checkmark.circle.fill")!
            return UIImage(named: "globalAnnotation")!
        case .local:
//            return UIImage(systemName: "exclamationmark.circle.fill")!
            return UIImage(named: "localAnnotation")!
        }
    }
}
