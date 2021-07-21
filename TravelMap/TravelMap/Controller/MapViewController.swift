//
//  MapViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit
import MapKit

enum MapMode {
    case globalMode
    case localMode
}

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var mapView: MapView = {
        let mapView = MapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var mapNavigationView: MapNavigationView = {
        let navigationView = MapNavigationView()
        navigationView.delegate = self
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        return navigationView
    }()
    
    //переделать
    var networkService = NetworkService()
    var coreDataService = CoreDataService()
    
    // код текущей страны
    private var countryCode: String?
    
    //режим отображения карты
    private var mapMode: MapMode = .globalMode
    
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        mapView.update(dataProvider: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGlobalAnnotation()
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(mapView)
        view.addSubview(mapNavigationView)
    }
    
    private func setupNavigationTools() {
        self.title = Constants.ControllerTitle.mapTitle
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            mapNavigationView.heightAnchor.constraint(equalToConstant: 44),
            mapNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 72),
            mapNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72),
            mapNavigationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Methods
    
//    // добавление стран на карту при запуске
//    private func setupGlobalAnnotation() {
//        guard let globalAnnotations = coreDataService.getCountryData(predicate: nil) else { return }
//
//        globalAnnotations.forEach { countryDTO in
//            addGlobalAnnotation(for: countryDTO)
//        }
//    }
    
    
    private func setupGlobalAnnotation() {
        
        switch mapMode {
        case .localMode:
            guard let countryCode = countryCode,
                  let globalAnnotation = coreDataService.getCountryData(predicate: countryCode) else { return }
            print(countryCode)
            
            if globalAnnotation.isEmpty {
                mapView.deleteAnnotationsFromMap(countryCode: countryCode, annotationType: .global)
                viewAllCountry()
            }
        case .globalMode:
            mapView.deleteAllAnnotations()
            guard let globalAnnotations = coreDataService.getCountryData(predicate: nil) else { return }
            globalAnnotations.forEach { countryDTO in
                addGlobalAnnotation(for: countryDTO)
            }
        }
    }
    
    // добавления новой страны/нового города
    private func addNewPlace(title: String, message: String, mapMode: MapMode) {
        let alertConrtoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertConrtoller.addTextField()
        
        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak alertConrtoller] (_) in
            let textField = alertConrtoller?.textFields?.first
            guard let place = textField?.text else { return }
            
            switch mapMode {
            case .globalMode:
                self.loadCountryCoordinate(country: place)
            case .localMode:
                self.loadCityCoordinate(city: place)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertConrtoller.addAction(okAction)
        alertConrtoller.addAction(cancelAction)
        present(alertConrtoller, animated: true)
    }
    
    // запрос для страны
    private func loadCountryCoordinate(country: String) {
        self.networkService.getCoordinate(placeType: Constants.Coordinate.countryCoordinte, placeName: country, countryCode: nil) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    if data.features.isEmpty {
                        self.showAlert(for: .country)
                    } else {
                        //получение данных
                        guard let countryCode = data.features.first?.properties.countryCode,
                              let country = data.features.first?.properties.country,
                              let latitude = data.features.first?.properties.lat,
                              let longitude = data.features.first?.properties.lon,
                              let countryBorder = data.features.first?.bbox else {
                            return
                        }
                        //добавление в DTO
                        let countryDTO = CountryDTO(countryCode: countryCode, country: country, latitude: latitude, longitude: longitude, border: countryBorder)
                        //добавление аннотации на карту
                        self.AddGlobalAnnotationOnMap(for: countryDTO)
                        //отборажение страны на карте
                        self.viewCountryOnMap(for: countryDTO)
                    }
                case .failure(let error):
                    self.showAlert(for: error)
                }
            }
        }
    }
    
    //добавление страны на карту
    private func AddGlobalAnnotationOnMap(for country: CountryDTO) {
        //проверка наличия страны в core data
        let result = self.coreDataService.addCountry(country: [country])
        
        if result == true {
            self.showAlert(for: .repeatCountry)
        } else {
            self.addGlobalAnnotation(for: country)
        }
    }
    
    //запрос для города
    private func loadCityCoordinate(city: String) {
        self.networkService.getCoordinate(placeType: Constants.Coordinate.cityCoordinate, placeName: city, countryCode: countryCode) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    if data.features.isEmpty {
                        self.showAlert(for: .city)
                    } else {
                        //получение данных
                        guard let cityId = data.features.first?.properties.placeId,
                              let countryCode = data.features.first?.properties.countryCode,
                              let city = data.features.first?.properties.city,
                              let latitude = data.features.first?.properties.lat,
                              let longitude = data.features.first?.properties.lon else {
                            return
                        }
                        //добавление в DTO
                        let CityDTO = CityDTO(cityId: cityId, countryCode: countryCode, city: city, latitude: latitude, longitude: longitude)
                        //добавление аннотации на карту
                        self.AddLocalAnnotationOnMap(for: CityDTO)
                    }
                case .failure(let error):
                    self.showAlert(for: error)
                }
            }
        }
    }
    
    //добавление города на карту
    private func AddLocalAnnotationOnMap(for city: CityDTO) {
        //проверка наличия города в core data
        let result = self.coreDataService.addCity(city: [city])
        
        if result == true {
            self.showAlert(for: .repeatCity)
        } else {
            self.addLocalAnnotation(for: city)
        }
    }
    
    private func showAlert(for error: NetworkServiceError) {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: message(for: error),
                                      preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(buttonOk)
        present(alert, animated: true)
    }
    
    private func message(for error: NetworkServiceError) -> String {
        switch error {
        case .country:
            return "Кажется вы ввели некоректное название страны"
        case .city:
            return "Кажется вы ввели некоректное название города"
        case .repeatCountry:
            return "Вы уже добаляли эту страну ранее"
        case .repeatCity:
            return "Вы уже добаляли эту страну ранее"
        case .network:
            return "Запрос сформирован некоорректно"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
    
    // MARK: - Methods for map
    
    private func viewCountryOnMap(for country: CountryDTO) {
        navigationItem.title = country.country
        
        let countryCenter = CLLocation(latitude: country.latitude, longitude: country.longitude)
        
        //масштабирование
        let latitudeDelta = abs(country.border[3] - country.border[1])*0.8
        let longitudeDelta = abs(country.border[2] - country.border[0])*0.8
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        let region = MKCoordinateRegion(center: countryCenter.coordinate, span: span)
        
        mapView.viewCountryOnMap(region: region)
        
        // режим отображения карты
        mapMode = .localMode
        // код текущей страны
        countryCode = country.countryCode
        //добавление/удаление городов на карту
        viewCityForCountry(for: mapMode)
    }
    
    private func viewAllCountry() {
        navigationItem.title = Constants.ControllerTitle.mapTitle
        
        let center = CLLocation(latitude: Constants.InitialCoordinate.latitude,
                                longitude: Constants.InitialCoordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Constants.InitialCoordinate.latitudeDelta,
                                    longitudeDelta: Constants.InitialCoordinate.longitudeDelta)
        let region = MKCoordinateRegion(center: center.coordinate, span: span)
        
        mapView.viewAllCountry(region: region)
        
        // режим отображения карты
        mapMode = .globalMode
        //добавление/удаление городов на карту
        viewCityForCountry(for: mapMode)
    }
    
    //добавление/удаление городов на карту
    private func viewCityForCountry(for mode: MapMode) {
        //получение городов для страны и core data
        guard let city = coreDataService.getCityData(predicate: countryCode) else { return }
        
        switch mode {
        case .localMode:
            addLocalAnnotations(for: city)
        case .globalMode:
            guard let countryCode = countryCode else { return }
            mapView.deleteAnnotationsFromMap(countryCode: countryCode, annotationType: .local)
        }
    }
    
    //добавление глобальной аннотации
    private func addGlobalAnnotation(for country: CountryDTO) {
        let coordinate = CLLocationCoordinate2D(latitude: country.latitude, longitude: country.longitude)
        let globalAnnotation = CustomAnnotation(coordinate: coordinate, title: country.country, subtitle: nil, countryCode: country.countryCode, placeId: nil, annotationType: .global)
        
        mapView.addAnnotationOnMap(globalAnnotation)
    }
    
    //добавление одной локальной аннотации
    private func addLocalAnnotation(for city: CityDTO) {
        let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        let localAnnotation = CustomAnnotation(coordinate: coordinate, title: city.city, subtitle: nil, countryCode: city.countryCode, placeId: city.cityId, annotationType: .local)
        
        mapView.addAnnotationOnMap(localAnnotation)
    }
    
    //добавление массива с локальными аннотациями
    private func addLocalAnnotations(for city: [CityDTO]) {
        var localAnnotations = [MKAnnotation]()
        city.forEach {
            let coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            let localAnnotation = CustomAnnotation(coordinate: coordinate, title: $0.city, subtitle: nil, countryCode: $0.countryCode, placeId: $0.cityId, annotationType: .local)
            localAnnotations.append(localAnnotation)
        }
        mapView.addAnnotationsOnMap(localAnnotations)
    }
}

// MARK: - Extensions (MKMapViewDelegate)

extension MapViewController: MKMapViewDelegate {
    
    //нажатие на метку
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let customAnnotation = view.annotation as? CustomAnnotation else { return }
        
        if customAnnotation.annotationType == .global {
            guard let countryCode = customAnnotation.countryCode,
                  let country = coreDataService.getCountryData(predicate: countryCode)?.first else { return }
            viewCountryOnMap(for: country)} else {
                return
            }
    }
    
    //нажатие на кнопку внутри метки
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let customAnnotation = view.annotation as? CustomAnnotation else { return }
        
        switch customAnnotation.annotationType {
        case .local:
            guard let cityId = customAnnotation.placeId,
                  let countryCode = customAnnotation.countryCode,
                  let title = customAnnotation.title else { return }
            
            let cityDTO = CityDTO(cityId: cityId, countryCode: countryCode, city: title, latitude: customAnnotation.coordinate.latitude, longitude: customAnnotation.coordinate.longitude)
            
            coreDataService.deleteCity(city: [cityDTO])
            mapView.removeAnnotation(customAnnotation)
        
        case .global:
            guard let countryCode = customAnnotation.countryCode,
                  let country = customAnnotation.title else { return }
            
            let countryViewController = CountryViewController(countryCode: countryCode, country: country)
            navigationController?.pushViewController(countryViewController, animated: true)
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapNavigationView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapNavigationView.isHidden = false
    }
}

// MARK: - Extensions (MapNavigationViewDelegate)

extension MapViewController: MapNavigationViewDelegate {
    func tappedBackButton() {
        viewAllCountry()
    }
    
    func tappedAddButton() {
        switch mapMode {
        case .globalMode:
            addNewPlace(title: "Новая страна", message: "Добавление новой страны", mapMode: mapMode)
        case .localMode:
            addNewPlace(title: "Новый город", message: "Добавление нового города", mapMode: mapMode)
        }
    }
}
