//
//  ImageView.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 17/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ImageView: UIView {

    var backgroundImage: UIImage? {
        didSet {
            let size = backgroundImage?.size ?? CGSize.zero
            frame = CGRect(origin: CGPoint.zero, size: size)
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }


}
