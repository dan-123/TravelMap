//
//  MapView.swift
//  TravelMap
//
//  Created by Даниил Петров on 02.07.2021.
//

import UIKit
import MapKit

//protocol MapViewDelegate: AnyObject {
//    func tappedLocalInformationButton(localAnnotation: CustomAnnotation)
//    func tappedGlobalInformationButton(countryCode: String, country: String)
//    func tappedGlobalAnnotation(_ countryCode: String)
//}

class MapView: UIView {
    
    // MARK: - Properties

//    weak var delegate: MapViewDelegate?
    
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
    //удаление одной аннотации
    func deleteAnnotationFromMap(_ annotation: MKAnnotation) {
        mapView.removeAnnotation(annotation)
    }
    //добавление массива с аннотациями
    func addAnnotationsOnMap(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    //удаление локальных аннотаций
    func deleteAnnotationsFromMap() {
        let annotations = mapView.annotations
        var localAnnotation = [MKAnnotation]()
        
        for annotation in annotations {
            guard let customAnnotation = annotation as? CustomAnnotation else { return }
            if customAnnotation.annotationType == .local {
                localAnnotation.append(customAnnotation)
            }
            mapView.removeAnnotations(localAnnotation)
        }
    }
    //отображение страны на карте
    func viewCountryOnMap(region: MKCoordinateRegion) {
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        mapView.setRegion(region, animated: true)
    }
    //отображение всех стран на карте
    func viewAllCountry(region: MKCoordinateRegion) {
        mapView.cameraBoundary = MKMapView.CameraBoundary()
        mapView.setRegion(region, animated: true)
    }
    
    func update(dataProvider: MKMapViewDelegate) {
        mapView.delegate = dataProvider
    }
}
