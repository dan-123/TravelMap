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
    var annotationData = AnnotationData()
    var coreDataService = CoreDataService()
    var countryCode: String?
    
    //словарь
//    var globalAnnotation = [String: [CountryCoordinateModel]]()
    
    //для стран
    var globalAnnotations = [CountryDTO]()
    
    //для меток
    var localAnnotations = [CustomAnnotationVew]()
    
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
        mapMode = .globalMode
        
//        globalAnnotations = coreDataService.showCountryData()
        
        
//        coreDataService.deleteAll()
//        for annotation in localAnnotations {
//            guard let annotation = annotation as?  else { return }
////            annotation.
//        }
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
    
    private func setupGlobalAnnotation() {
        guard let globalAnnotations = coreDataService.getCountryData() else { return }
        print("добавленные страны: \(globalAnnotations)")
        
        
    }
    
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
                        
                        
                        //ошибочные данные bbox от сервера для Франции
                        if country == "France" {
                            let countryBorder = [-7.518476, 39.190641, 12.520585, 53.088162]
                            
                            #warning("временное решение")
                            self.checkAndAddAnnotationOnMap(country, latitude, longitude, countryBorder)
                            
                            //отборажение страны на карте
                            self.viewCountryOnMap(country, latitude, longitude, countryBorder)

                            self.countryCode = data.features.first?.properties.countryCode
                            
                        } else {
                            #warning("временное решение")
                            //добавление в core data
                            var result = self.coreDataService.addCountry(country: [countryDTO])
                            print("result = \(result)")
                            
                            self.checkAndAddAnnotationOnMap(country, latitude, longitude, countryBorder)
                            
                            //отборажение страны на карте
                            self.viewCountryOnMap(country, latitude, longitude, countryBorder)

                            self.countryCode = data.features.first?.properties.countryCode
                        }
                    }
                case .failure(let error):
                    self.showAlert(for: error)
                }
            }
        }
    }
    
    private func checkAndAddAnnotationOnMap(_ country: String, _ latitude: Double, _ longitude: Double, _ countryBorder: [Double]) {
        //проверка на наличие страны на карте
        if self.annotationData.globalAnnotation[country] != nil {
            self.showAlert(for: .repeatCountry)
        } else {
            
            //добавление в словарь
            self.annotationData.globalAnnotation[country] = [latitude, longitude, countryBorder[0], countryBorder[1], countryBorder[2], countryBorder[3]]
            //добавление аннотации на карту
            self.addGlobalAnnotation(country, latitude, longitude)
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
                        guard let city = data.features.first?.properties.city,
                              let latitude = data.features.first?.properties.lat,
                              let longitude = data.features.first?.properties.lon else {
                            return
                        }
                        #warning("добавить проверку на наличие города")
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self.addLocalAnnotation(coordinate, city, nil)
                    }
                case .failure(let error):
                    self.showAlert(for: error)
                }
            }
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
        case .localAnnotation:
            return "Для добавлении новой метки необходимо выбрать страну"
        case .coordinate:
            return "Данная точка не соответсвует выбранной стране"
        case .network:
            return "Запрос сформирован некоорректно"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
    
    // MARK: - Methods for map
    
    private func viewCountryOnMap(_ country: String, _ latitude: Double, _ longitude: Double, _ countryBorder: [Double]) {
        navigationItem.title = country
        
        let countryCenter = CLLocation(latitude: latitude, longitude: longitude)
        
        //масштабирование
        let latitudeDelta = abs(countryBorder[3] - countryBorder[1])*0.8
        let longitudeDelta = abs(countryBorder[2] - countryBorder[0])*0.8
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        let region = MKCoordinateRegion(center: countryCenter.coordinate, span: span)
        
        mapView.viewCountryOnMap(region: region)
        
        //mode
        mapMode = .localMode
    }

    private func viewAllCountry() {
        navigationItem.title = ""
        
        let center = CLLocation(latitude: Constants.InitialCoordinate.latitude,
                                longitude: Constants.InitialCoordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Constants.InitialCoordinate.latitudeDelta,
                                    longitudeDelta: Constants.InitialCoordinate.longitudeDelta)
        let region = MKCoordinateRegion(center: center.coordinate, span: span)
        
        mapView.viewAllCountry(region: region)
    }

    private func addGlobalAnnotation(_ country: String, _ latitude: Double, _ longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let globalAnnotation = CustomAnnotation(coordinate: coordinate, title: country, subtitle: nil, annotationType: .global)
        
        mapView.addAnnotationOnMap(globalAnnotation)
    }
    
    //данные заполняются пользователем
    private func addLocalAnnotation(_ coordinate: CLLocationCoordinate2D, _ title: String?, _ subtitle: String?) {
        
//        let latitude = 30.9953683
//        let longitude = 18.9877132
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let title = "Новая метка"
//        let subtitle = "local subtitle"
        
        let localAnnotation = CustomAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, annotationType: .local)

        mapView.addAnnotationOnMap(localAnnotation)
        
        //массив
//        mapView.map.
//        localAnnotations.append(localAnnotation)
    }
    
}


// MARK: - Extensions

extension MapViewController: MapViewDelegate {
    
    func tappedGlobalAnnotation(country: String) {
        #warning("временное решение")
        guard let countryInfo = annotationData.globalAnnotation[country] else { return }
        
        let latitude = countryInfo[0]
        let longitude = countryInfo[1]
        let countryBorder = [countryInfo[2],
                             countryInfo[3],
                             countryInfo[4],
                             countryInfo[5]]
        
        viewCountryOnMap(country, latitude, longitude, countryBorder)
    }
    
//    func tappedLocalInformationButton(latitude: Double, longitude: Double) {
//        let placemarkViewController = PlacemarkViewController(placeLabelText: "")
//        navigationController?.pushViewController(placemarkViewController, animated: true)
//    }
    
    func tappedGlobalInformationButton(country: String) {
//        tabBarController?.selectedIndex = 0
        guard let text = navigationItem.title else { return }
        let placemarkViewController = CountryViewController(country: text)
        navigationController?.pushViewController(placemarkViewController, animated: true)
        
//        let placesViewController = PlacesViewController()
//        tabBarController?.selectedViewController = placesViewController
    }
}
