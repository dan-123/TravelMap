//
//  MapView.swift
//  TravelMap
//
//  Created by Даниил Петров on 02.07.2021.
//

import UIKit
import MapKit

final class MapView: UIView {
    
    // MARK: - Properties
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsCompass = false
        mapView.isRotateEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElement()
        setupConstraint()
        centerLocation()
        
        //регистрация нового класса с идентификатором повторного использования представления карты по умолчанию
        mapView.register(CustomAnnotationVew.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
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
    
    // MARK: - Methods
    
    private func centerLocation() {
        let center = CLLocationCoordinate2D(latitude: Constants.InitialCoordinate.latitude,
                                            longitude: Constants.InitialCoordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Constants.InitialCoordinate.latitudeDelta,
                                    longitudeDelta: Constants.InitialCoordinate.longitudeDelta)
        let coordinateRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //добавление одной аннотации
    func addAnnotationOnMap(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }
    //добавление массива с аннотациями
    func addAnnotationsOnMap(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    
    //удаление одной аннотации
    func deleteAnnotationFromMap(_ annotation: MKAnnotation) {
        mapView.removeAnnotation(annotation)
    }
    
    //удаление аннотаций по коду страны и типу
    func deleteAnnotationsFromMap(countryCode: String, annotationType: AnnotationType) {
        let annotations = mapView.annotations
        
        annotations.forEach { annotation in
            guard let customAnnotation = annotation as? CustomAnnotation,
                  let code = customAnnotation.countryCode else { return }
            
            if (code == countryCode && customAnnotation.annotationType == annotationType) {
                mapView.removeAnnotation(customAnnotation)
            }
        }
    }
    
    //удаление аннотаций по типу
    func deleteAnnotationsFromMap( annotationType: AnnotationType) {
        let annotations = mapView.annotations
        
        annotations.forEach { annotation in
            guard let customAnnotation = annotation as? CustomAnnotation else { return }
            
            if (customAnnotation.annotationType == annotationType) {
                mapView.removeAnnotation(customAnnotation)
            }
        }
    }
    
    //удаление всех аннотаций
    func deleteAllAnnotations() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    //отображение страны на карте
    func viewCountryOnMap(region: MKCoordinateRegion) {
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        mapView.setRegion(region, animated: true)
    }
    //отображение всех стран на карте
    func viewAllCountry(region: MKCoordinateRegion) {
        //отмена выделеня метки для страны
        let selectedAnnotation = mapView.selectedAnnotations
        mapView.deselectAnnotation(selectedAnnotation.first, animated: true)
        //отображение полной карты
        mapView.cameraBoundary = MKMapView.CameraBoundary()
        mapView.setRegion(region, animated: true)
    }
    
    func update(dataProvider: MKMapViewDelegate) {
        mapView.delegate = dataProvider
    }
}
