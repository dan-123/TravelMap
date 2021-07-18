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
    
    lazy var countryInfo: CountryView = {
        countryInfo = CountryView()
        countryInfo.delegateCollection = self
        countryInfo.delegateTable = self
        countryInfo.translatesAutoresizingMaskIntoConstraints = false
        return countryInfo
    }()
    
    private let countryCode: String
    private let country: String
    
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
       
        loadCountryImageURL(counrty: country)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        try? coreDataService.frcCity.performFetch()
        countryInfo.reloadCityTable()
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(countryInfo)
    }
    
    private func setupNavigationTools() {
        self.title = country
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.circle.fill"), style: .plain, target: self, action: #selector(deleteCountry))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            countryInfo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            countryInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            countryInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            countryInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Action
    
    @objc private func deleteCountry() {
        print("удаление страны")
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
                        self.imageStringURL.append(image.src.large2x)
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
                    self.countryInfo.reloadCountryImage()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - Extensions (CountryCollectionViewDelegate)

extension CountryViewController: CountryCollectionViewDelegate {
    func getImageCountry(index: Int) -> UIImage {
        if index < imageCountry.count {
            return imageCountry[index]
        } else {
            return UIImage(systemName: "photo") ?? UIImage()
        }
    }
}

// MARK: - Extensions (CountryTableViewDelegate)

extension CountryViewController: CountryTableViewDelegate {
    func getNumberOfSection(_ section: Int) -> Int {
        guard let sections = coreDataService.frcCity.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func getData(at indexPath: IndexPath) -> City {
        return (coreDataService.frcCity.object(at: indexPath))
    }
}
