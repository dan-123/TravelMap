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
    
    lazy var mapView: MapView = {
        let mapView = MapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    //переделать
    var networkService = NetworkService()
    var coreDataService = CoreDataService()
    
    // код текущей страны
    private var countryCode: String?
    
    //режим отображения
    private enum MapMode {
        case globalMode
        case localMode
    }
    
    private var mapMode: MapMode = .globalMode
    
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        
        setupGlobalAnnotation()
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(mapView)
    }
    
    private func setupNavigationTools() {
        //        self.title = "Карта"
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(tappedLeftBarButton))
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(tappedRightBarButton))
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
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
    
    @objc private func tappedLeftBarButton() {
        viewAllCountry()
    }
    
    @objc private func tappedRightBarButton() {
        switch mapMode {
        case .globalMode:
            addNewPlace(title: "Новая страна", message: "Добавление новой страны", mapMode: mapMode)
        case .localMode:
            addNewPlace(title: "Новый город", message: "Добавление нового города", mapMode: mapMode)
        }
    }
    
    // MARK: - Methods
    
    // добавление стран на карту при запуске
    private func setupGlobalAnnotation() {
        guard let globalAnnotations = coreDataService.getCountryData(predicate: nil) else { return }
        
        globalAnnotations.forEach { countryDTO in
            addGlobalAnnotation(for: countryDTO)
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
        navigationItem.title = ""
        
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
            mapView.deleteAnnotationsFromMap()
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


// MARK: - Extensions

extension MapViewController: MapViewDelegate {
    //нажатие на страну
    func tappedGlobalAnnotation(_ countryCode: String) {
        guard let country = coreDataService.getCountryData(predicate: countryCode)?.first else { return }
        viewCountryOnMap(for: country)
    }
    
    //нажатие на город
    func tappedLocalInformationButton(localAnnotation: CustomAnnotation) {
        guard let cityId = localAnnotation.placeId,
              let countryCode = localAnnotation.countryCode,
              let title = localAnnotation.title else { return }
        
        let cityDTO = CityDTO(cityId: cityId, countryCode: countryCode, city: title, latitude: localAnnotation.coordinate.latitude, longitude: localAnnotation.coordinate.longitude)
        
        //удаление из core data
        coreDataService.deleteCity(city: [cityDTO])
    }
    
    //нажатие на кнопку информации у страны
    func tappedGlobalInformationButton(country: String) {
        let placemarkViewController = CountryViewController(countryCode: "", country: country)
        navigationController?.pushViewController(placemarkViewController, animated: true)
    }
    
}
