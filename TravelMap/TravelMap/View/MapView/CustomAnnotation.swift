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
    let annotationType: AnnotationType
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, annotationType: AnnotationType) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.annotationType = annotationType
        super.init()
    }
    
    // свойство для первого варианта из CustomAnnotationVew
    var annotationTintColor: UIColor   {
        switch annotationType {
        case .global:
            return .blue
        case .local:
            return .green
        }
    }
    
    var image: UIImage {
        #warning("force")
        switch annotationType {
        case .global:
            return UIImage(systemName: "checkmark.circle.fill")!
        case .local:
            return UIImage(systemName: "exclamationmark.circle.fill")!
        }
    }
}
