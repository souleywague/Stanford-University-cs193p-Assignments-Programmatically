//
//  ImageViewController.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 17/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    // MARK: - User Interface Properties
    
    private var scrollViewWidth: NSLayoutConstraint!
    private var scrollViewHeight: NSLayoutConstraint!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 5.0
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var imageView: ImageView = {
        let imageView = ImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var backgroundImage: UIImage? {
        get {
            return imageView.backgroundImage
        } set {
            scrollView.zoomScale = 1.0
            imageView.backgroundImage = newValue
            
            let size = newValue?.size ?? CGSize.zero
            updateScrollView(with: size)
        }
    }
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = imageView.backgroundImage?.size ?? CGSize.zero
        
        setupLayout()
        setupDelegates()
        updateScrollView(with: size)
    }
    
    
    // MARK: - Setup Functions
    
    private func updateScrollView(with size: CGSize) {
        scrollView.contentSize = size
        scrollViewWidth.constant = size.width
        scrollViewWidth.constant = size.height
    }
    
    private func setupDelegates() {
        scrollView.delegate = self
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
}

// MARK: UIScrollViewDelegate

extension ImageViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
