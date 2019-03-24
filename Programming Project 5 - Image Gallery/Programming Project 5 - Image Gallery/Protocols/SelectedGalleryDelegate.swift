//
//  SelectedGalleryDelegate.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 24/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

protocol SelectedGalleryDelegate: AnyObject {
    func didSelectNewGallery(selectedGallery: ImageGallery, galleriesStore: ImageGalleryStore)
}
