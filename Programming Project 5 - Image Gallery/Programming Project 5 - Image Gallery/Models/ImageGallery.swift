//
//  ImageGallery.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 21/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

/// Model representing a gallery with it's images.
struct ImageGallery: Hashable, Codable {
    
    /// Model representing a gallery's image.
    struct Image: Hashable, Codable {
        
        // MARK: - Hashable
        
        var hashValue: Int {
            return imagePath?.hashValue ?? 0
        }
        
        static func ==(lhs: ImageGallery.Image, rhs: ImageGallery.Image) -> Bool {
            return lhs.imagePath == rhs.imagePath
        }
        
        // MARK: - Properties
        
        /// The image's URL.
        var imagePath: URL?
        
        /// The image's aspect ratio.
        var aspectRatio: Double
        
        /// The fetched image's data.
        var imageData: Data?
        
        // MARK: - Initializer
        
        init(imagePath: URL?, aspectRatio: Double) {
            self.imagePath = imagePath
            self.aspectRatio = aspectRatio
        }
     }
    
    // MARK: - Properties
    
    /// The gallery's identifier.
    let identifier: String = UUID().uuidString
    
    /// The gallery's images.
    var images: [Image]
    
    /// The gallery's title.
    var title: String
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return identifier.hashValue
    }
    
    static func ==(lhs: ImageGallery, rhs: ImageGallery) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
