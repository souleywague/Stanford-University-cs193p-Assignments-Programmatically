//
//  AppDelegate.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 17/03/2019.
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
        let imageGalleryTableViewController = ImageGalleryTableViewController()
        let imageGalleryCollectionViewController = ImageGalleryCollectionViewController()
        let imageGalleryTableViewNavigationController = UINavigationController(rootViewController: imageGalleryTableViewController)
        let imageGalleryCollectionViewNavigationController = UINavigationController(rootViewController: imageGalleryCollectionViewController)
        
        splitViewController.viewControllers = [imageGalleryTableViewNavigationController, imageGalleryCollectionViewNavigationController]
        
        window?.rootViewController = splitViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }


}

