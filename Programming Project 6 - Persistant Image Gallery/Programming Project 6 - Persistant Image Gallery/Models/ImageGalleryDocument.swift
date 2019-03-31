//
//  ImageGalleryDocument.swift
//  Programming Project 6 - Persistant Image Gallery
//
//  Created by Souley on 31/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ImageGalleryDocuement: UIDocument {
    
    // MARK: - Properties
    
    /// The document thumbnail.
    var thumbnail: UIImage?
    
    /// The gallery stored by this document.
    var gallery: ImageGallery?
    
    // MARK: UIDocument Life Cycle
    
    override func contents(forType typeName: String) throws -> Any {
        return gallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let data = contents as? Data {
            gallery = ImageGallery(json: data)
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey : thumbnail]
        }
        return attributes
    }
    
}
