//
//  MapView.swift
//  TravelMap
//
//  Created by Даниил Петров on 02.07.2021.
//

import UIKit
import MapKit

class MapView: UIView {
    
    // MARK: - Properties
    
    lazy var map: MKMapView = {
        let map = MKMapView()

        map.showsCompass = false
        map.isRotateEnabled = false
//        map.delegate = self
//        map.region.center = CLLocationCoordinate2D(latitude: 64.6863136, longitude: 97.7453061)
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElement()
        setupConstraint()
//        let latitude = 55.453699
//        let longitude = 72.597645
//        centerToLocation2(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
//                          span: MKCoordinateSpan(latitudeDelta: latitude*2, longitudeDelta: longitude*2))
        //        centerToLocation3(location: CLLocation(latitude: 42, longitude: 0), regionRadius: 3500000)
        centerLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElement() {
        addSubview(map)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            map.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            map.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            map.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
    private func centerLocation() {
        let center = CLLocationCoordinate2D(latitude: Constants.InitialCoordinate.latitude,
                                            longitude: Constants.InitialCoordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Constants.InitialCoordinate.latitudeDelta,
                                    longitudeDelta: Constants.InitialCoordinate.longitudeDelta)
        let coordinateRegion = MKCoordinateRegion(center: center, span: span)
        map.setRegion(coordinateRegion, animated: true)
      }
    
    //    private func centerToLocation2(location: CLLocationCoordinate2D, span: MKCoordinateSpan) {
    //        let coordinateRegion = MKCoordinateRegion(center: location, span: span)
    //        map.setRegion(coordinateRegion, animated: true)
    //      }
    
    //    private func centerToLocation3(location: CLLocation, regionRadius: CLLocationDistance) {
    //        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
    //                                                  latitudinalMeters: regionRadius,
    //                                                  longitudinalMeters: regionRadius)
    //        map.setRegion(coordinateRegion, animated: true)
    //      }
        
}

// MARK: - Extensions

//extension MapView: MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // 2
//        guard let annotation = annotation as? CustomAnnotation else {
//            return nil
//        }
//        // 3
//        let identifier = "customAnnotation"
//        var view: MKMarkerAnnotationView
//        // 4
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            // 5
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
//}

