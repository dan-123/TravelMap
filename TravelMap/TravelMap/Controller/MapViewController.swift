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
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward.circle.fill"), style: .plain, target: self, action: #selector(addCountry))
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addCountry))
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
    
    @objc private func addCountry() {
        #warning("добавить список всех стран, с возможностью выбора")
        
        print("добавление новой страны")
        var country: String?
        
        let alertConrtoller = UIAlertController(title: "Новая страна", message: "Добавление новой страны", preferredStyle: .alert)

        alertConrtoller.addTextField()
        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak alertConrtoller] (_) in
            let textField = alertConrtoller?.textFields?[0]
            country = textField?.text
            print(country!)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertConrtoller.addAction(okAction)
        alertConrtoller.addAction(cancelAction)
        
        present(alertConrtoller, animated: true)
    }
    
    // MARK: - Methods
    
}


// MARK: - Extensions


