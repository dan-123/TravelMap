//
//  CustomTabBarController.swift
//  TravelMap
//
//  Created by Даниил Петров on 08.07.2021.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private lazy var customTabBar: CustomTabBarView = {
       let customTabBar = CustomTabBarView()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        return customTabBar
    }()

    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupConstraint()
        setupControllers()
    }
    
    // MARK: - UI
    
    private func setupElements() {
        tabBar.addSubview(customTabBar)
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 0),
            customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: 0),
            customTabBar.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupControllers() {
        
        let pointViewController = UINavigationController.init(rootViewController: PlacesViewController())
//        pointViewController.tabBarItem.image = 
        let mapViewConroller = UINavigationController.init(rootViewController: MapViewController())
        let thirdViewController = UINavigationController.init(rootViewController: ThirdViewController())

        viewControllers = [pointViewController, mapViewConroller, thirdViewController]
        selectedIndex = 1
        
        
//        thirdViewController.tabBarItem = UITabBarItem(title: "тест", image: UIImage(named: "settings"), tag: 1)
    }
    
    // MARK: - Methods
}
