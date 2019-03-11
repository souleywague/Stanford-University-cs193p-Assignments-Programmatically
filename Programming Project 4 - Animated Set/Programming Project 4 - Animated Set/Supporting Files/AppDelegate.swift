//
//  AppDelegate.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
       
        let splitViewController = UISplitViewController()
        let themeChooserViewController = ThemeChooserViewController()
        let concentrationGameViewController = ConcentrationGameViewController()
        let setGameViewController = SetGameViewController()
        
        let themeChooserNavigationController = UINavigationController(rootViewController: themeChooserViewController)
        let concentrationGameNavigationController = UINavigationController(rootViewController: concentrationGameViewController)
        let setGameNavigationController = UINavigationController(rootViewController: setGameViewController)
        
        splitViewController.viewControllers = [themeChooserNavigationController, concentrationGameNavigationController]
    
        let tabBarController: UITabBarController = {
            let tabBarController = UITabBarController()
            
            tabBarController.viewControllers = [splitViewController, setGameNavigationController]
            
            splitViewController.tabBarItem = UITabBarItem(title: "Concentration",
                                                                 image: UIImage(named: "R"),
                                                                 selectedImage: UIImage(named: "R Selected"))
            
            setGameViewController.tabBarItem = UITabBarItem(title: "Set",
                                                            image: UIImage(named: "Y"),
                                                            selectedImage: UIImage(named: "Y Selected"))
            
            return tabBarController
        }()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }


}

