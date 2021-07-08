//
//  AppDelegate.swift
//  TravelMap
//
//  Created by Даниил Петров on 22.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let item1 = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 1)
        let item2 = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 1)
        let item3 = UITabBarItem.init(tabBarSystemItem: .downloads, tag: 1)
        
        let pointViewController = UINavigationController.init(rootViewController: PlacesViewController())
        pointViewController.tabBarItem = item1
        
        let mapViewConroller = UINavigationController.init(rootViewController: MapViewController())
        mapViewConroller.tabBarItem = item2
        
        let thirdViewController = ThirdViewController()
        thirdViewController.tabBarItem = item3
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [pointViewController, mapViewConroller, thirdViewController]
        tabBar.selectedIndex = 1
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
        return true
    }
}

