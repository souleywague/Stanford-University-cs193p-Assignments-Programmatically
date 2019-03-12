//
//  ThemeChooserDelegate.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 12/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

protocol ThemeChooserDelegate: AnyObject {
    func didChooseTheme(_ theme: Theme)
}
