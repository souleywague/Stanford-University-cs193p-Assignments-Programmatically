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
        
        let gallerySelectionTableViewController = GallerySelectionTableViewController()
        let galleryDisplayCollectionViewController = GalleryDisplayCollectionViewController()
        
        let gallerySelectionTableViewNavigationController = UINavigationController(rootViewController: gallerySelectionTableViewController)
        let galleryDisplayCollectionNavigationController = UINavigationController(rootViewController: galleryDisplayCollectionViewController)
        
        splitViewController.viewControllers = [gallerySelectionTableViewNavigationController, galleryDisplayCollectionNavigationController]
        
        window?.rootViewController = splitViewController
        
        let galleriesStore = ImageGalleryStore()
        
        if let gallerySelectionTableViewController = (window?.rootViewController as? UISplitViewController)?.viewControllers.first?.contents as? GallerySelectionTableViewController {
            gallerySelectionTableViewController.galleriesStore = galleriesStore
        }
        
        if let galleryDisplayCollectionViewController = (window?.rootViewController as? UISplitViewController)?.viewControllers.last?.contents as? GalleryDisplayCollectionViewController {
            galleryDisplayCollectionViewController.galleriesStore = galleriesStore
            galleryDisplayCollectionViewController.gallery = galleriesStore.galleries.first
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }


}

