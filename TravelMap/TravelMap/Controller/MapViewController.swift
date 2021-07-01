//
//  MapViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var mapView: MapView = {
        let mapView = MapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    //переделать
    var networkService = NetworkService()
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(mapView)
    }
    
    private func setupNavigationTools() {
        self.title = "Карта путешествий"
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(addNewCountry))
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
        #warning("добавить список всех стран, с возможностью выбора")
        print("добавление новой страны")
        var country: String?
        
        let alertConrtoller = UIAlertController(title: "Новая страна", message: "Добавление новой страны", preferredStyle: .alert)
        alertConrtoller.addTextField()
        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak alertConrtoller] (_) in
            let textField = alertConrtoller?.textFields?[0]
            country = textField?.text
            print(country!)
            // добавить проверку на правиьлность введеной страны
            guard let country = country else { return }
            self.loadCountryCoordinate(for: country)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertConrtoller.addAction(okAction)
        alertConrtoller.addAction(cancelAction)
        present(alertConrtoller, animated: true)
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
                              let londitude = data.features.first?.properties.lon else {
                            return
                        }
                        self.addCountryAnnotation(title: country, latitude: latitude, longitude: londitude)
                        
//                        print(data.features.first?.properties.country)
//                        print(data.features.first?.properties.lat)
//                        print(data.features.first?.properties.lon)
//                        print(data.features.first?.bbox)
                        
                    }
                case .failure(let error):
                    self.showAlert(for: error)
                }
            }
        }
    }
    
    private func showAlert(for error: NetworkServiceError) {
        let alert = UIAlertController(title: "Упс, что-то пошло не так",
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
        case .network:
            return "Запрос сформирован некоорректно"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
    
    private func addCountryAnnotation(title: String, latitude: Double, longitude: Double) {
        let CountryAnnotation = CustomAnnotation()
        CountryAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude) // Италия
        CountryAnnotation.title = title
        //достать картинку из сети
        CountryAnnotation.imageOfCountry = "checkmark.square.fill"
        
        mapView.mapView.addAnnotation(CountryAnnotation)
        // 6.6272658, 35.2889616, 18.7844746, 47.0921462
        //        mapView.mapView.region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //        let rect = MKMapRect(x: 47, y: 6.6, width: 100, height: 100)
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latitude/2, longitudeDelta: longitude/2)
        mapView.mapView.region = .init(center: center, span: span)
    }
    
    
    
}


// MARK: - Extensions


