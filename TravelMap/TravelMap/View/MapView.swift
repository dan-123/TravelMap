//
//  MapView.swift
//  TravelMap
//
//  Created by Даниил Петров on 30.06.2021.
//

import UIKit
import MapKit
import AudioToolbox

class MapView: UIView {
    
    // MARK: - Properties
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(mapViewTapped))) // delegate
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    //тестовая метка
    lazy var annotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        
        annotation.title = "Тестовая точка"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 65.235214, longitude: 88.662736)
        annotation.coordinate = CLLocationCoordinate2D(latitude: 55.75115080026314, longitude: 37.614772693365) // москва
        return annotation
    }()
    
    var annotations = [MKPointAnnotation]()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElement()
        setupConstraint()
        setupAnnotation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupElement() {
        addSubview(mapView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    func setupAnnotation() {
            mapView.showAnnotations([annotation], animated: true)
//        let annotationItem = MKMapItem(placemark: MKPlacemark(coordinate: c))
//        mapView.addOverlay(annotationItem as! MKOverlay)
        }
    
    // MARK: - Actions
    
    @objc private func mapViewTapped(longGesture: UILongPressGestureRecognizer) {
        print("нажатие на карту")
        
        let poin = longGesture.location(in: mapView) // self?
        let coordinate = mapView.convert(poin, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        annotations.append(annotation)
        mapView.addAnnotation(annotation)
        
//        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        
        print("Метка создалась: \(annotations)")
    }
    
}





// MARK: - Extensions

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("нажатие на метку")
        
    }
}
