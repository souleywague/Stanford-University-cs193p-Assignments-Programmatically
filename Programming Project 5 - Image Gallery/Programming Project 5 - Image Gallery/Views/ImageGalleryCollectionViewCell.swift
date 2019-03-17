//
//  ImageGalleryCollectionViewCell.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 17/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
        
    // MARK: - Initializers
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Cell View Properties
    
    lazy var label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()
    
    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
    
    // MARK: - Setup Functions
    
    private func setupLayout() {
        contentView.addSubview(label)
        contentView.addSubview(spinner)
        
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

// MARK: - Extensions

extension ImageGalleryCollectionViewCell {
    static var defaultWidth: CGFloat = 139
}
