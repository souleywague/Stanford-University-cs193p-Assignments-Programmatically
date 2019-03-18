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
    
    private lazy var cellView: UIView = {
        let cellView = UIView()
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        return cellView
    }()
    
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
        contentView.addSubview(cellView)
        cellView.addSubview(label)
        cellView.addSubview(spinner)
        
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        spinner.centerXAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
    }
}

// MARK: - Extensions

extension ImageGalleryCollectionViewCell {
    static var defaultWidth: CGFloat = 139
}
