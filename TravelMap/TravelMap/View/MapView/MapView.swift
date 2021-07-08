//
//  MapView.swift
//  TravelMap
//
//  Created by Даниил Петров on 02.07.2021.
//

import UIKit
import MapKit

protocol MapViewDelegate: AnyObject {
    func tappedLocalInformationButton(latitude: Double, longitude: Double)
    func tappedGlobalInformationButton(country: String)

    func tappedGlobalAnnotation(country: String)
}

class MapView: UIView {
    
    // MARK: - Properties

    weak var delegate: MapViewDelegate?
    
    lazy var map: MKMapView = {
        let map = MKMapView()

        map.showsCompass = false
        map.isRotateEnabled = false
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElement()
        setupConstraint()

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
}

// MARK: - Extensions

extension MapView: MKMapViewDelegate {
    
    //    нажатие на метку
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let customAnnotation = view.annotation as? CustomAnnotation else { return }
        
        if customAnnotation.annotationType == .global {
            guard let country = customAnnotation.title else { return }
            delegate?.tappedGlobalAnnotation(country: country)} else {
                return
            }
    }
    
    //    нажатие на кнопку внутри метки
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let customAnnotation = view.annotation as? CustomAnnotation else { return }
        
        switch customAnnotation.annotationType {
        case .local:
            delegate?.tappedLocalInformationButton(latitude: customAnnotation.coordinate.latitude,
                                                   longitude: customAnnotation.coordinate.longitude)
        case .global:
            guard let country = customAnnotation.title else { return }
            delegate?.tappedGlobalInformationButton(country: country)
        }
    }
}

