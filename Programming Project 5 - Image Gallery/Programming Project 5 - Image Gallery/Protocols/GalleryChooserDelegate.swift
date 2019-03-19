//
//  GalleryChooserDelegate.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 19/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

protocol GalleryChooserDelegate: AnyObject {
    func didChooseGallery(currentGallery: String, imageDataStorage: [ImageProperties])
}
