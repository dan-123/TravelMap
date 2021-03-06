//
//  CustomAnnotationVew.swift
//  TravelMap
//
//  Created by Даниил Петров on 04.07.2021.
//

import MapKit

// MARK: - Вариант аннотации с рамкой. При нажатии уменьшается до точки.

final class CustomAnnotationVew: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else { return }

            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            switch customAnnotation.annotationType {
            case .global:
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            case .local:
                rightCalloutAccessoryView = UIButton(type: .close)
            }

            markerTintColor = customAnnotation.annotationTintColor
            glyphImage = customAnnotation.image
        }
    }
}
