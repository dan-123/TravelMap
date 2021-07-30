//
//  CountryViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

import Foundation
import UIKit

final class CountryViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var countryView: CountryView = {
        countryView = CountryView()
        countryView.translatesAutoresizingMaskIntoConstraints = false
        return countryView
    }()
    
    private let country: String
    private let countryCode: String
    private var imageCountry = [UIImage]()
    
    //переделать
    lazy var coreDataService: CoreDataService = {
        let coreDataService = CoreDataService()
        coreDataService.delegate = self
        return coreDataService
    }()
    
    // MARK: - Dependencies
    
    let imageLoaderService: ImageLoaderServiceProtocol
    let coordinateLoaderService: CoordinateCityLoaderServiceProtocol
    
    // MARK: - Init

    init(imageLoaderService: ImageLoaderServiceProtocol = ImageLoaderService(),
         coordinateLoaderService: CoordinateCityLoaderServiceProtocol = CoordinateLoaderService(),
         countryCode: String,
         country: String) {
        self.imageLoaderService = imageLoaderService
        self.coordinateLoaderService = coordinateLoaderService
        self.countryCode = countryCode
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        countryView.update(dataProvider: self)
        loadCountryImage(country: country)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        coreDataService.predicateForFrcCity = countryCode
        try? coreDataService.frcCity.performFetch()
        countryView.reloadCityTable()
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(countryView)
    }
    
    private func setupNavigationTools() {
        self.title = country
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCity))
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteCountry))
        self.navigationItem.rightBarButtonItems = [deleteButton, addButton]
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            countryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            countryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            countryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            countryView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Action
    
    @objc private func deleteCountry() {
        
        let alertConrtoller = UIAlertController(title: "Удаление страны", message: "Вы уверены что хотите удалить страну?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            self.deleteCountryData()
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertConrtoller.addAction(okAction)
        alertConrtoller.addAction(cancelAction)
        present(alertConrtoller, animated: true)
    }
    
    @objc private func addCity() {
        let alertConrtoller = UIAlertController(title: "Новый город", message: "Добавление нового города", preferredStyle: .alert)
        alertConrtoller.addTextField()

        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak alertConrtoller] _ in
            let textField = alertConrtoller?.textFields?.first
            guard let city = textField?.text else { return }
            self.loadCity(city: city)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertConrtoller.addAction(okAction)
        alertConrtoller.addAction(cancelAction)
        present(alertConrtoller, animated: true)
    }

    // MARK: - Methods
    
    private func loadCity(city: String) {
        coordinateLoaderService.loadCityCoordinate(city: city, countryCode: countryCode) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("added new city in table")
            case .failure(let error):
                self.showAlert(for: error)
            }
        }
    }
    
    private func loadCountryImage(country: String) {
        imageLoaderService.loadImage(country: country) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.imageCountry = data
                self.countryView.reloadCountryImage()
            case .failure(let error):
                self.showAlert(for: error)
            }
        }
    }
    
    private func deleteCountryData() {
        guard let countryData = coreDataService.getCountryData(predicate: countryCode) else { return }
        
        countryData.forEach { country in
            coreDataService.deleteCountry(country: [country])
        }
        
        if let cityData = coreDataService.getCityData(predicate: countryCode) {
            cityData.forEach { city in
                coreDataService.deleteCity(city: [city])
            }
        }
    }
}

// MARK: - Extensions (UICollectionViewDataSource)

extension CountryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCountry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.reusableIdentifier,
                                                            for: indexPath) as? CountryCollectionViewCell
        else { return UICollectionViewCell() }
        
        if indexPath.row < imageCountry.count {
            cell.setImage(imageCountry[indexPath.row])
        } else {
//            cell.setImage(UIImage(systemName: "photo"))
            cell.setImage(UIImage())
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
//    }
}

// MARK: - Extensions (UITableViewDataSource)

extension CountryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = coreDataService.frcCity.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        let city = (coreDataService.frcCity.object(at: indexPath))
        cell.selectionStyle = .none
        cell.textLabel?.text = city.city
        return cell
    }
}

// MARK: - Extensions (UITableViewDelegate)

extension CountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let city = coreDataService.frcCity.object(at: indexPath)
        
        let cityDTO = CityDTO(cityId: city.cityId, countryCode: city.countryCode, city: city.city, latitude: city.latitude, longitude: city.longitude)

        coreDataService.deleteCity(city: [cityDTO])
    }
}

// MARK: - Extensions (CoreDataSeriviceDelegate)
extension CountryViewController: CoreDataSeriviceDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.countryView.reloadCityTable()
        }
    }
}
