//
//  CountryViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

import Foundation
import UIKit

class CountryViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var countryView: CountryView = {
        countryView = CountryView()
        countryView.translatesAutoresizingMaskIntoConstraints = false
        return countryView
    }()
    
    private let countryCode: String
    private let country: String
    
    //массив для url с картинками
    private var imageStringURL = [String]()
    //массив с картинками
    private var imageCountry = [UIImage]()
    
    var networkService: ImageNetworkServiceProtocol
    
    //переделать
    lazy var coreDataService: CoreDataService = {
        let coreDataService = CoreDataService()
        coreDataService.delegate = self
        return coreDataService
    }()
    
    // MARK: - Init

    init(countryCode: String, country: String, networkService: ImageNetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
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
       
        loadCountryImageURL(counrty: country)
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
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteCountry))
        let rightBarButton2 = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(deleteCountry))
//        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        self.navigationItem.rightBarButtonItems = [rightBarButton, rightBarButton2]
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
    
    @objc private func editSubtitle(gesture: UITapGestureRecognizer) {
        print("редактирование описания")
    }
    
    // MARK: - Methods
    
    private func loadCountryImageURL(counrty: String) {
        self.networkService.getCountryImageURL(country: counrty) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    for image in data.photos {
                        self.imageStringURL.append(image.src.medium)
                    }
                    self.loadImage()
                case .failure(let error):
                    print("Image error: \(error)")
                }
            }
        }
    }
    
    private func loadImage() {
        self.networkService.loadImage(imageStringURL: imageStringURL) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    self.imageCountry = data
                    print(self.imageCountry.count)
                    self.countryView.reloadCountryImage()
                case .failure(let error):
                    print(error)
                }
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
        return Constants.Image.perPage
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
