//
//  ImageSelectionDelegate.swift
//  Programming Project 6 - Persistant Image Gallery
//
//  Created by Souley on 31/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

/// The gallery image selection delegate protocol.
protocol ImageSelectionDelegate: AnyObject {
    func didSelectImage(selectedImage: UIImage)
}
