//
//  CustomTabBarController.swift
//  TravelMap
//
//  Created by Даниил Петров on 08.07.2021.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let mapButtonDiameter: CGFloat = 75
    
//    private let redColor: UIColor = UIColor(red: 254.0 / 255.0, green: 116.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
//    private let greenColor: UIColor = UIColor(red: 102.0 / 255.0, green: 166.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)

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
    
    private lazy var placesButton: UIButton = {
        let button = UIButton()
//        button.layer.cornerRadius = mapButtonDiameter /2 
        button.backgroundColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var placesImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "places")
        image.contentMode = .scaleToFill
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Init
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        tabBar = CustomTabBar()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupConstraint()
        setupControllers()
    }
    
    // MARK: - UI
    
    private func setupElements() {
        tabBar.addSubview(mapButton)
        mapButton.addSubview(mapImageView)
        
        tabBar.addSubview(placesButton)
        placesButton.addSubview(placesImageView)
    }
    
    private func setupConstraint() {
        //map
        NSLayoutConstraint.activate([
            mapButton.heightAnchor.constraint(equalToConstant: mapButtonDiameter),
            mapButton.widthAnchor.constraint(equalToConstant: mapButtonDiameter),
            mapButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
//            mapButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -20),
            mapButton.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: -10),
            
            mapImageView.heightAnchor.constraint(equalToConstant: 45),
            mapImageView.widthAnchor.constraint(equalToConstant: 45),
            mapImageView.centerXAnchor.constraint(equalTo: mapButton.centerXAnchor),
            mapImageView.centerYAnchor.constraint(equalTo: mapButton.centerYAnchor)
        ])
        
        //places
        NSLayoutConstraint.activate([
            placesButton.heightAnchor.constraint(equalToConstant: mapButtonDiameter-25),
            placesButton.widthAnchor.constraint(equalToConstant: mapButtonDiameter-25),
            placesButton.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 24),
            placesButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -20),

            placesImageView.heightAnchor.constraint(equalToConstant: 25),
            placesImageView.widthAnchor.constraint(equalToConstant: 25),
            placesImageView.centerXAnchor.constraint(equalTo: placesButton.centerXAnchor),
            placesImageView.centerYAnchor.constraint(equalTo: placesButton.centerYAnchor)
        ])
    }
    
    private func setupControllers() {
        let pointViewController = UINavigationController.init(rootViewController: PlacesViewController())
        let mapViewConroller = UINavigationController.init(rootViewController: MapViewController())
        let thirdViewController = UINavigationController.init(rootViewController: ThirdViewController())
        
        
        
        viewControllers = [pointViewController, mapViewConroller, thirdViewController]
        selectedIndex = 1
        
        
//        thirdViewController.tabBarItem = UITabBarItem(title: "тест", image: UIImage(named: "settings"), tag: 1)
    }
    
    // MARK: - Methods
}
