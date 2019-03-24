//
//  GalleryDisplayCollectionViewController.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 21/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class GalleryDisplayCollectionViewController: UIViewController {
    
    // MARK: - User Interface Properties
    
    private lazy var galleryDisplayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.backgroundColor = .white
        
        collectionView.isScrollEnabled = true
        collectionView.dragInteractionEnabled = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var trashButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        
        return barButtonItem
    }()
    
    // MARK: - Properties
    
    /// The collection view's cell reuse identifier
    private let reuseIdentifier = "imageCellID"
    
    /// The galleries' store.
    var galleriesStore: ImageGalleryStore?
    
    /// The gallery to be displayed.
    var gallery: ImageGallery! {
        didSet {
            title = gallery?.title
            galleryDisplayCollectionView.reloadData()
        }
    }
    
    /// The maximum collection view's item width.
    private var maximumItemWidth: CGFloat? {
        return galleryDisplayCollectionView.frame.size.width
    }
    
    /// The minimum collection view's item width.
    private var minimumItemWidth: CGFloat? {
        return (galleryDisplayCollectionView.frame.size.width / 2) - 5
    }
    
    /// The width of each cell in the collection view.
    private lazy var itemWidth: CGFloat = {
        return minimumItemWidth ?? 0
    }()
    
    /// The collection view's flow layout.
    private var flowLayout: UICollectionViewFlowLayout? {
        return galleryDisplayCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
    }
    
    // MARK: - Methods
    
    /// Returns the image a the provided indexPath.
    private func getImage(at indexPath: IndexPath) -> ImageGallery.Image? {
        return gallery.images[indexPath.item]
    }
    
    /// Inserts the provided image at the provided indexPath.
    private func insertImage(_ image: ImageGallery.Image, at indexPath: IndexPath) {
        gallery.images.insert(image, at: indexPath.item)
        print("Updated \(gallery.images.count)")
        galleriesStore?.updateGallery(gallery)
    }
    
    // MARK: - Actions
    
    @objc private func didPinch(_ sender: UIPinchGestureRecognizer) {
        guard let maximumItemWidth = maximumItemWidth else { return }
        guard let minimumItemWidth = minimumItemWidth else { return }
        
        guard itemWidth <= maximumItemWidth else { return }
        
        if sender.state == .began || sender.state == .changed {
            let scaledWidth = itemWidth * sender.scale
            
            if scaledWidth <= maximumItemWidth, scaledWidth >= minimumItemWidth {
                itemWidth = scaledWidth
                flowLayout?.invalidateLayout()
            }
            sender.scale = 1
        }
    }
    
    // MARK: - Setup Functions
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(galleryDisplayCollectionView)
        
        galleryDisplayCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        galleryDisplayCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        galleryDisplayCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        galleryDisplayCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
}

// MARK: - Collection View Data Source

extension GalleryDisplayCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let galleryImage = getImage(at: indexPath) else {
            return cell
        }
        
        if let imageCell = cell as? ImageCollectionViewCell {
            if let data = galleryImage.imageData, let image = UIImage(data: data) {
                imageCell.imageView.image = image
                imageCell.isLoading = false
            } else {
                imageCell.isLoading = true
            }
        }
        return cell
    }
    
}

// MARK: - Flow Layout Delegate

extension GalleryDisplayCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let galleryImage = gallery.images[indexPath.item]
        let itemHeight = itemWidth / CGFloat(galleryImage.aspectRatio)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - Collection View Drag Delegate

extension GalleryDisplayCollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        
        return getDragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        
        return getDragItems(at: indexPath)
    }
    
    private func getDragItems(at indexPath: IndexPath) -> [UIDragItem] {
        var dragItems = [UIDragItem]()
        
        if let galleryImage = getImage(at: indexPath) {
            if let imageURL = galleryImage.imagePath as NSURL? {
                let urlItem = UIDragItem(itemProvider: NSItemProvider(object: imageURL))
                urlItem.localObject = galleryImage
                dragItems.append(urlItem)
            }
        }
        return dragItems
    }
    
}

// MARK: - Collection View Drop Delegate

extension GalleryDisplayCollectionViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if collectionView.hasActiveDrag {
            // If the drag is from this collection view, the image is not needed.
            return session.canLoadObjects(ofClass: URL.self)
        } else {
            return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard gallery != nil else { return UICollectionViewDropProposal(operation: .forbidden) }
        
        // Determines if the drag was initiated from the app in case of reordering.
        let isDraggedFromTheApp = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        
        return UICollectionViewDropProposal(operation: isDraggedFromTheApp ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                // The drag was initiated from this collection view.
                if let galleryImage = item.dragItem.localObject as? ImageGallery.Image {
                    collectionView.performBatchUpdates({
                        self.gallery.images.remove(at: sourceIndexPath.item)
                        self.gallery.images.insert(galleryImage, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                // The drag was initiated from outside of the app.
                let placeholderContext = coordinator.drop(item.dragItem,
                                                          to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: reuseIdentifier))
                
                // Creates a new image to hold the place for the dragged one.
                var draggedImage = ImageGallery.Image(imagePath: nil, aspectRatio: 1)
                
                // Loads the image/
                _ = item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            draggedImage.aspectRatio = image.aspectRatio
                        }
                    }
                }
                
                // Loads the URL.
                _ = item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
                    if let url = provider?.imageURL {
                        draggedImage.imagePath = url
                        
                        // Downloads the image from the fetched url.
                        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                            DispatchQueue.main.async {
                                if let data = data, let _ = UIImage(data: data) {
                                    placeholderContext.commitInsertion { indexPath in
                                        draggedImage.imageData = data
                                        self.insertImage(draggedImage, at: indexPath)
                                    }
                                } else {
                                    // There was an error. Remove the placeholder.
                                    placeholderContext.deletePlaceholder()
                                }
                            }
                        } .resume()
                    }
                }
            }
        }
    }
    
}

// MARK: - UIDropInteractionDelegate

extension GalleryDisplayCollectionViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: URL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let item = session.items.first else { return }
        guard let droppedImage = item.localObject as? ImageGallery.Image else { return }
        guard let index = gallery.images.firstIndex(of: droppedImage) else { return }
        
        gallery.images.remove(at: index)
        galleriesStore?.updateGallery(gallery)
    }
}

