//
//  CountryAnnotationView.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

import UIKit
import MapKit

class CountryAnnotationView: MKPinAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
