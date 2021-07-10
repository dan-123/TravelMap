//
//  CustomTabBarView.swift
//  TravelMap
//
//  Created by Даниил Петров on 09.07.2021.
//

import UIKit

class CustomTabBarView: UIView {
    
    // MARK: - Properties
    
    private let placesButtonDiameter: CGFloat = 20
    private let mapButtonDiameter: CGFloat = 75
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = mapButtonDiameter / 2
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mapImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "map")
        image.contentMode = .scaleToFill
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    //
    //    private lazy var placesImageView: UIImageView = {
    //        let image = UIImageView()
    //        image.image = UIImage(named: "places")
    //        image.contentMode = .scaleToFill
    //        image.tintColor = .white
    //        image.translatesAutoresizingMaskIntoConstraints = false
    //        return image
    //    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElement()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupElement() {
        addSubview(mapButton)
        mapButton.addSubview(mapImageView)
        
        //        addSubview(placesImageView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            mapButton.heightAnchor.constraint(equalToConstant: mapButtonDiameter),
            mapButton.widthAnchor.constraint(equalToConstant: mapButtonDiameter),
            mapButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            //            mapButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -20),
            mapButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            mapImageView.heightAnchor.constraint(equalToConstant: 45),
            mapImageView.widthAnchor.constraint(equalToConstant: 45),
            mapImageView.centerXAnchor.constraint(equalTo: mapButton.centerXAnchor),
            mapImageView.centerYAnchor.constraint(equalTo: mapButton.centerYAnchor)
        ])
        
        //        NSLayoutConstraint.activate([
        //            placesImageView.heightAnchor.constraint(equalToConstant: placesButtonDiameter),
        //            placesImageView.widthAnchor.constraint(equalToConstant: placesButtonDiameter),
        //            //            mapButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        //            placesImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        //            placesImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50)
        //            //            mapButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -20),
        //        ])
        
    }
    
    // MARK: - Methods
}

// MARK: - Extensions
