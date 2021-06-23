//
//  MapViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit
import MapKit
import AudioToolbox

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(mapViewTapped)))
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    //тестовая метка
    lazy var annotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        
        annotation.title = "Тестовая точка"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 59.925737, longitude: 30.297420)
        annotation.coordinate = CLLocationCoordinate2D(latitude: 65.235214, longitude: 88.662736)
        return annotation
    }()
    
    var annotations = [MKPointAnnotation]()

    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        
        setupAnnotation()
        
//        addPolygon()
        
    }
    
    // MARK: - UI
    
    func setupAnnotation() {
        mapView.showAnnotations([annotation], animated: true)
//        let annotationItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
//        mapView.addOverlays(annotationItem)
    }
    
    private func setupElements() {
        view.addSubview(mapView)
    }
    
    private func setupNavigationTools() {
        self.title = "Карта путешествий"
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareTravelMap))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)

    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
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
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        
        print("Метка создалась: \(annotations)")
    }
    
    @objc private func shareTravelMap() {
        print("нажатие на кнопку поделиться")
        addPolygon()
        // добавить обработку кнопки по работе с изображением
    }
    
    // MARK: - Methods
    
    private func addPolygon() {
        let points = [CLLocationCoordinate2DMake(66.413794, 85.454728),
                       CLLocationCoordinate2DMake(67.303127, 91.255509),
                       CLLocationCoordinate2DMake(64.724110, 88.838517),
                       CLLocationCoordinate2DMake(66.413794, 85.454728)]
        
        let polygon = MKPolygon(coordinates: points, count: points.count)
        
//        let polygon2 = MKPolygonRenderer(overlay: polygon)
//        polygon2.fillColor = UIColor(red: 0, green: 0.847, blue: 1, alpha: 0.25)
        
//        mapView.addOverlay(polygon)
        mapView.addOverlay(polygon)
    }
}


// MARK: - Extensions

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("нажатие на метку")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let points = [CLLocationCoordinate2DMake(66.413794, 85.454728),
                       CLLocationCoordinate2DMake(67.303127, 91.255509),
                       CLLocationCoordinate2DMake(64.724110, 88.838517),
                       CLLocationCoordinate2DMake(66.413794, 85.454728)]

        let polygon = MKPolygon(coordinates: points, count: points.count)
        
//        mapView.addOverlay(polygon)
        
        let polygonView = MKPolygonRenderer(overlay: polygon)
        polygonView.fillColor = UIColor(red: 1, green: 0.847, blue: 1, alpha: 0.25)

        return polygonView
    }
}
