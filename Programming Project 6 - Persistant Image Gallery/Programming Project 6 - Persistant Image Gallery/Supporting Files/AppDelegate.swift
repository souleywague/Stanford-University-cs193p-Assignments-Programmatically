//
//  AppDelegate.swift
//  Programming Project 6 - Persistant Image Gallery
//
//  Created by Souley on 31/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let imageGalleryDocumentBrowserViewController = ImageGalleryDocumentBrowserViewController()
        
        window?.rootViewController = imageGalleryDocumentBrowserViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }


}

