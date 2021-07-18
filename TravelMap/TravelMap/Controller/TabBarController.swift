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
        
        let pointViewController = UINavigationController.init(rootViewController: PlacesViewController())
        pointViewController.tabBarItem = UITabBarItem(title: "Места", image: UIImage(systemName: "mappin.and.ellipse"), tag: 1)
        
        let mapViewConroller = UINavigationController.init(rootViewController: MapViewController())
        mapViewConroller.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), tag: 1)
        
        let settingViewController = UINavigationController.init(rootViewController: SettingViewController())
        settingViewController.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), tag: 1)

        viewControllers = [pointViewController, mapViewConroller, settingViewController]
        selectedIndex = 1
    }
}
