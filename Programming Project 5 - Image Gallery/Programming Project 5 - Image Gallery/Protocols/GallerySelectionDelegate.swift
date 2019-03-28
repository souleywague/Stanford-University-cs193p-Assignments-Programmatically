//
//  GallerySelectionDelegate.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 28/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

protocol GallerySelectionDelegate: AnyObject {
    func didSelectGallery(selectedGallery: ImageGallery, galleriesStore: ImageGalleryStore)
}
