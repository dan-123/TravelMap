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
    var globalAnnotation = GlobalAnnotation()
    
    //словарь
//    var globalAnnotation = [String: [CountryCoordinateModel]]()
    
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        
        mapView.map.register(CustomAnnotationVew.self,
                             forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.map.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(mapViewTapped)))
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(mapView)
    }
    
    private func setupNavigationTools() {
        self.title = "Карта путешествий"
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(testFunc))
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addNewCountry))
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
    
    @objc private func addNewCountry() {
        let alertConrtoller = UIAlertController(title: "Новая страна", message: "Добавление новой страны", preferredStyle: .alert)
        alertConrtoller.addTextField()
        
        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak alertConrtoller] (_) in
            let textField = alertConrtoller?.textFields?.first
            guard let country = textField?.text else { return }
            self.loadCountryCoordinate(for: country)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertConrtoller.addAction(okAction)
        alertConrtoller.addAction(cancelAction)
        present(alertConrtoller, animated: true)
    }
    
    @objc private func testFunc() {
        viewAllCountry()
    }
    
    @objc private func mapViewTapped(longGesture: UILongPressGestureRecognizer) {
        print("нажатие на карту")
        
        //срабатывает после отпускания
        guard longGesture.state == .ended else { return }
        
        let poin = longGesture.location(in: mapView.map)
        let coordinate = mapView.map.convert(poin, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        annotations.append(annotation)
        
//        checkAnnotationCoordinate(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        addLocalAnnotation(coordinate: annotation.coordinate)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        
//        print("Метка создалась")
    }
    
    // MARK: - Methods
    
    private func loadCountryCoordinate(for country: String) {
        self.networkService.getCountryCoordinate(countryName: country) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    if data.features.isEmpty {
                        self.showAlert(for: .country)
                    } else {
                        guard let country = data.features.first?.properties.country,
                              let latitude = data.features.first?.properties.lat,
                              let longitude = data.features.first?.properties.lon,
                              let countryBorder = data.features.first?.bbox else {
                            return
                        }
                        
                        //ошибочные данные bbox от сервера для Франции
                        if country == "France" {
                            let countryBorder = [-7.518476, 39.190641, 12.520585, 53.088162]
                            
                            #warning("временное решение")
                            self.checkAndAddAnnotationOnMap(country, latitude, longitude, countryBorder)
                            
                            //отборажение страны на карте
                            self.viewCountryOnMap(country, latitude, longitude, countryBorder)
                            
                        } else {
                            #warning("временное решение")
                            self.checkAndAddAnnotationOnMap(country, latitude, longitude, countryBorder)
                            
                            //отборажение страны на карте
                            self.viewCountryOnMap(country, latitude, longitude, countryBorder)
                        }
//                        print("country: \(self.globalAnnotation.globalAnnotation)")
                    }
                case .failure(let error):
                    self.showAlert(for: error)
                }
            }
        }
    }
    
    private func checkAndAddAnnotationOnMap(_ country: String, _ latitude: Double, _ longitude: Double, _ countryBorder: [Double]) {
        //проверка на наличие страны на карте
        if self.globalAnnotation.globalAnnotation[country] != nil {
            self.showAlert(for: .repeatCountry)
        } else {
            
            //добавление в словарь
            self.globalAnnotation.globalAnnotation[country] = [latitude,
                                                               longitude,
                                                               countryBorder[0],
                                                               countryBorder[1],
                                                               countryBorder[2],
                                                               countryBorder[3]]
            //добавление аннотации на карту
            self.addGlobalAnnotation(country, latitude, longitude)
        }
    }
    
//    private func checkAnnotationCoordinate(latitude: Double, longitude: Double) {
//        print(latitude)
//        print(longitude)
//        self.networkService.checkAnnotationCoordinate(latitude: latitude, longitude: longitude) { responce in
//            DispatchQueue.main.async {
//                switch responce {
//                case .success(let data):
//                    print(data.features.first?.properties.country)
//                    let currentCountry = self.navigationItem.title
//                    print("navigator \(self.navigationItem.title)")
//                    print(latitude)
//                    print(longitude)
//                    if data.features.first?.properties.country != currentCountry {
//                        self.showAlert(for: .coordinate)
//                        print("failure coordinate")
//                    } else {
//                        print("OK")
//                        let annotation = CLLocationCoordinate2D(latitude: latitude,
//                                                                longitude: longitude)
//                        self.addLocalAnnotation(coordinate: annotation)
//                        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
//                    }
//                case .failure(let error):
//                    print("failure \(error.localizedDescription)")
//                    self.showAlert(for: error)
//                }
//            }
//        }
//    }
    
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
        case .repeatCountry:
            return "Вы уже добаляли эту страну ранее"
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
        
        //view
        mapView.map.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        mapView.map.setRegion(region, animated: true)
    }

    private func viewAllCountry() {
        navigationItem.title = "TravelMap"
        
        let center = CLLocation(latitude: Constants.InitialCoordinate.latitude,
                                longitude: Constants.InitialCoordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Constants.InitialCoordinate.latitudeDelta,
                                    longitudeDelta: Constants.InitialCoordinate.longitudeDelta)
        let region = MKCoordinateRegion(center: center.coordinate, span: span)
        
        //view
        mapView.map.cameraBoundary = MKMapView.CameraBoundary()
        mapView.map.setRegion(region, animated: true)
    }

    private func addGlobalAnnotation(_ country: String, _ latitude: Double, _ longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let globalAnnotation = CustomAnnotation(coordinate: coordinate, title: country, subtitle: nil, annotationType: .global)
        
        //view
        mapView.map.addAnnotation(globalAnnotation)
    }
    
    //данные заполняются пользователем
    private func addLocalAnnotation(coordinate: CLLocationCoordinate2D) {
        
//        let latitude = 30.9953683
//        let longitude = 18.9877132
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let title = "Local"
        let subtitle = "local subtitle"
        
        let localAnnotation = CustomAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, annotationType: .local)
        
        //view
        mapView.map.addAnnotation(localAnnotation)
    }
    
}


// MARK: - Extensions

extension MapViewController: MapViewDelegate {
    func tappedGlobalAnnotation(country: String) {
        #warning("временное решение")
        guard let countryInfo = globalAnnotation.globalAnnotation[country] else { return }
        
        let latitude = countryInfo[0]
        let longitude = countryInfo[1]
        let countryBorder = [countryInfo[2],
                             countryInfo[3],
                             countryInfo[4],
                             countryInfo[5]]
        
        viewCountryOnMap(country, latitude, longitude, countryBorder)
    }
    
    func tappedLocalInformationButton(latitude: Double, longitude: Double) {
        tabBarController?.selectedIndex = 0
        print("annotation latitude: \(latitude)")
        print("annotation longitude: \(longitude)")
    }
}
