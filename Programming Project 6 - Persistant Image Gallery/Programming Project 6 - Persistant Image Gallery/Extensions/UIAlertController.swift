//
//  UIAlertController.swift
//  Programming Project 6 - Persistant Image Gallery
//
//  Created by Souley on 31/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /// Adds a new alert action to the alert controller.
    func addActionWith(title: String, style: UIAlertAction.Style = .default, handler: Optional<(UIAlertAction) -> Swift.Void> = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        
        addAction(action)
        
        return action
    }
    
}
