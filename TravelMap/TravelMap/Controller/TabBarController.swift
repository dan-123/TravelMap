//
//  TabBarController.swift
//  TravelMap
//
//  Created by Даниил Петров on 08.07.2021.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
    }
    
    // MARK: - Methods
    
    private func setupControllers() {
        
        let placesViewController = UINavigationController.init(rootViewController: PlacesViewController())
        placesViewController.tabBarItem = UITabBarItem(title: Constants.ControllerTitle.placesTitle, image: UIImage(systemName: "mappin.and.ellipse"), tag: 1)
        
        let mapViewConroller = UINavigationController.init(rootViewController: MapViewController())
        mapViewConroller.tabBarItem = UITabBarItem(title: Constants.ControllerTitle.mapTitle, image: UIImage(systemName: "map"), tag: 1)
        
        let settingViewController = UINavigationController.init(rootViewController: SettingViewController())
        settingViewController.tabBarItem = UITabBarItem(title: Constants.ControllerTitle.settingTitle, image: UIImage(systemName: "gearshape"), tag: 1)

        viewControllers = [placesViewController, mapViewConroller, settingViewController]
        selectedIndex = 1
    }
}
