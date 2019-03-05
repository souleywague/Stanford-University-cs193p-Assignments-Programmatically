//
//  AppDelegate.swift
//  Programming Project 2 - Set
//
//  Created by Souley on 05/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let setGameViewController = SetGameViewController()
        
        window?.rootViewController = setGameViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }

}

