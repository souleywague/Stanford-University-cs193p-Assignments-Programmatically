//
//  UIViewController.swift
//  Programming Project 6 - Persistant Image Gallery
//
//  Created by Souley on 31/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

/// Adds alert capabilities to all view controllers.
extension UIViewController {
    
    /// Returns an alert controller with the passed title and message.
    func makeAlertWith(title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    /// Presents a warning alert with the provided title and message.
    func presentWarningWith(title: String, message: String, handler: Optional<() -> ()> = nil) {
        let alert = makeAlertWith(title: title, message: message)
        _ = alert.addActionWith(title: "Ok", style: .default)
        
        present(alert, animated: true, completion: handler)
    }

}
