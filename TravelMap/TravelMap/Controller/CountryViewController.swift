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
        countryInfo.delegate = self
        countryInfo.translatesAutoresizingMaskIntoConstraints = false
        return countryInfo
    }()
    
    private let country: String
    private var imageStringURL = [String]()
    private var imageCoutry = [UIImage]()
    
    //переделать
    var networkService = NetworkService()
    
    // MARK: - Init

    init(country: String) {
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
        print("загрузка картинки")
        self.networkService.loadImage(imageStringURL: imageStringURL) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    self.imageCoutry = data
                    print(self.imageCoutry.count)
                    self.countryInfo.reloadCountryImage()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - Extensions

extension CountryViewController: CountryViewDelegate {
    func getImageCountry(index: Int) -> UIImage {
        if index < imageCoutry.count {
            return imageCoutry[index]
        } else {
            //force
            return UIImage(systemName: "photo")!
        }
    }
    
    
}
