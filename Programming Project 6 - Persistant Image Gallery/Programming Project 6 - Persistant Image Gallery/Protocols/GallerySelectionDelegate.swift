//
//  GallerySelectionDelegate.swift
//  Programming Project 6 - Persistant Image Gallery
//
//  Created by Souley on 01/04/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

/// The gallery selection delegate protocol. 
protocol GallerySelectionDelegate: AnyObject {
    func didSelectGallery(galleryDocument: ImageGalleryDocument, imageRequestManager: ImageRequestManager)
}
