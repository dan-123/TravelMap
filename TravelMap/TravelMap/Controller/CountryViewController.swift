//
//  CountryViewController.swift
//  TravelMap
//
//  Created by Даниил Петров on 06.07.2021.
//

import Foundation
import UIKit
import CoreData

class CountryViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var countryView: CountryView = {
        countryView = CountryView()
        countryView.translatesAutoresizingMaskIntoConstraints = false
        return countryView
    }()
    
    private let countryCode: String
    private let country: String
    
    private lazy var frcCity: NSFetchedResultsController<City> = {
        let frcCity = NSFetchedResultsController<City>()
        return frcCity
    }()
    
    //массив для url с картинками
    private var imageStringURL = [String]()
    //массив с картинками
    private var imageCountry = [UIImage]()
    
    //переделать
    var networkService = NetworkService()
    let coreDataService = CoreDataService()
    
    // MARK: - Init

    init(countryCode: String, country: String) {
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
        
        frcCity = coreDataService.GetFrcForCity(predicate: countryCode)
        print("countryCode = \(countryCode)")
        try? frcCity.performFetch()
        countryView.reloadCityTable()
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(countryView)
    }
    
    private func setupNavigationTools() {
        self.title = country
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.circle.fill"), style: .plain, target: self, action: #selector(deleteCountry))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
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
        print("удаление страны")
        deleteCountryData()
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

// MARK: - Extensions (UICollectionViewDelegate)

extension CountryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - Extensions (UITableViewDataSource)

extension CountryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frcCity.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        let city = (frcCity.object(at: indexPath))
        cell.textLabel?.text = city.city
        return cell
    }
}
