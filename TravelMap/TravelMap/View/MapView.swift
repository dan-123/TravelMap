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
        mapView.showsCompass = false
        mapView.isRotateEnabled = false
        mapView.region.center = CLLocationCoordinate2D(latitude: 64.6863136, longitude: 97.7453061)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    //тестовая метка
//    lazy var annotation: MKPointAnnotation = {
//        let annotation = MKPointAnnotation()
//        annotation.title = "Russia"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 64.6863136, longitude: 97.7453061) // Россия
//        return annotation
//    }()
    
    //тестовая кастомная метка
    lazy var imageAnnotation: CustomAnnotation = {
        let annotation = CustomAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 64.6863136, longitude: 97.7453061) // Россия
        annotation.title = "Russia 2"
        annotation.subtitle = "Subtitle"
        annotation.imageOfCountry = "checkmark.circle.fill"
        return annotation
    }()
    
//    lazy var annotationView: MKMarkerAnnotationView = {
//        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "test")
//        annotationView.canShowCallout = true
//        annotationView.animatesWhenAdded = true
//        annotationView.glyphImage = UIImage(systemName: "checkmark.circle.fill")
//        annotationView.glyphTintColor = .systemBlue
//        annotationView.markerTintColor = .white
//        annotationView.translatesAutoresizingMaskIntoConstraints = false
//        return annotationView
//    }()
    
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
//        mapView.showAnnotations([annotation], animated: true)
//        mapView.addAnnotation(annotation)
//        mapView.showAnnotations([imageAnnotation], animated: true)
        
        mapView.addAnnotation(imageAnnotation)
        
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
        
        print("Метка создалась")
    }
    
}



// MARK: - Extensions

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("нажатие на метку")
        
        guard let latitude = view.annotation?.coordinate.latitude,
              let longitude = view.annotation?.coordinate.longitude else { return }

        mapView.region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        #warning("не работает масштабирование")
        let latitudeDelta = latitude / 2
        let longitudeDelta = longitude / 2
        mapView.region.span.latitudeDelta = latitudeDelta
        mapView.region.span.longitudeDelta = longitudeDelta
//        print("latitude = \(latitude)")
//        print("longitude = \(longitude)")
//        print("latitudeDelta = \(latitudeDelta)")
//        print("longitudeDelta = \(longitudeDelta)")
//        print("mapView.region.span.latitudeDelta = \(mapView.region.span.latitudeDelta)")
//        print("mapView.region.span.longitudeDelta = \(mapView.region.span.longitudeDelta)")
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        let reuseId = "Country"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            //                let data = NSData(contentsOf: URL(string: annotation.imageOfCountry!)!)
            annotationView?.image = UIImage(systemName: annotation.imageOfCountry!)
        }
        else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}
