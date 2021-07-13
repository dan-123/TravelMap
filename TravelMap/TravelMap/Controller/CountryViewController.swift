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
    
    var firstPhoto: String
    var secondPhoto: String
    var thirdPhoto: String
    
    //массив картинок
    var imageCoutry = [UIImage]()
    
    //переделать
    var imageNetworkService = ImageNetworkService()
    
    // MARK: - Init

    init(firstPhoto: String, secondPhoto: String, thirdPhoto: String) {
        
        self.firstPhoto = firstPhoto
        self.secondPhoto = secondPhoto
        self.thirdPhoto = thirdPhoto
        
        super.init(nibName: nil, bundle: nil)
        
        setupElements()
        setupConstraint()
        setupNavigationTools()
        //didload
        loadImage()
        
        view.backgroundColor = .systemBackground
        
//        placemarkInfo.placemarkSubtitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editSubtitle)))
//        placeLabel.text = placeLabelText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElements() {
        view.addSubview(countryInfo)
    }
    
    private func setupNavigationTools() {
        self.title = "Информация о метке"
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
        print(firstPhoto)
        print(secondPhoto)
        print(thirdPhoto)
        print(imageCoutry.count)
    }
    
    @objc private func editSubtitle(gesture: UITapGestureRecognizer) {
        print("редактирование описания")
    }
    
    // MARK: - Methods
    
    private func loadImage() {
        print("загрузка картинки")
        imageNetworkService.loadImage(firstURL: firstPhoto, secondURL: secondPhoto, thirdURL: thirdPhoto) { responce in
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
