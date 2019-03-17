//
//  ImagePropertiesModel.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 17/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

struct ImageProperties {
    let url: URL
    let aspectRatio: CGFloat
}

extension ImageProperties: Codable {}
