//
//  ImageGalleryCollectionViewController.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 17/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewController: UIViewController {

    // MARK: - User Interface Properties
    
    private lazy var imageGalleryCollectionView: UICollectionView = {
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
    
    // MARK: - Model
    
    weak var imageGalleryTableViewController: ImageGalleryTableViewController?
    
    var currentGallery: String? {
        didSet {
            title = currentGallery ?? nil
        }
    }
    
    var imageDataStorage: [ImageProperties] = [] {
        didSet {
            if currentGallery != nil {
                imageGalleryTableViewController?.imageGalleryData[currentGallery!] = imageDataStorage
            }
        }
    }
    
    // MARK: - Collection View CellIDs
    
    private var imageCellID = "imageCellID"
    private var dropPlaceholderCellID = "dropPlaceholderCellID"
    
    // MARK: - Private Properties
    
    private var cellScale: CGFloat = 1.0
    private var indexPathsForDragging: [IndexPath] = []
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.rightBarButtonItem = trashButton
        
        navigationController?.title = currentGallery
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCollectionView()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let navigationController = splitViewController?.viewControllers.last as? UINavigationController {
            navigationController.navigationBar.addInteraction(UIDropInteraction(delegate: self))
        } else {
            navigationController?.navigationBar.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    // MARK: Setup Functions
    
    private func setupCollectionView() {
        imageGalleryCollectionView.dataSource = self
        imageGalleryCollectionView.delegate = self
        imageGalleryCollectionView.dragDelegate = self
        imageGalleryCollectionView.dropDelegate = self
        
        imageGalleryCollectionView.register(ImageGalleryCollectionViewCell.self, forCellWithReuseIdentifier: imageCellID)
        imageGalleryCollectionView.register(ImageGalleryCollectionViewCell.self, forCellWithReuseIdentifier: dropPlaceholderCellID)
        
        addPinchGesture()
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(imageGalleryCollectionView)
        
        imageGalleryCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        imageGalleryCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        imageGalleryCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        imageGalleryCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }

}

// MARK: - UICollectionViewDelegate

extension ImageGalleryCollectionViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension ImageGalleryCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataStorage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellID, for: indexPath)
        
        if let cell = cell as? ImageGalleryCollectionViewCell {
            // TODO: move updateImageForCell() to the ImageGalleryCollectionViewCell
            updateImageForCell(cell, fromURL: imageDataStorage[indexPath.item].url)
            addTapGesture(to: cell)
            flowLayout?.invalidateLayout()
        }
        return cell
    }
    
    private func updateImageForCell(_ cell: ImageGalleryCollectionViewCell, fromURL url: URL) {
        cell.backgroundImage = nil
        cell.spinner.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: url)
            
            DispatchQueue.main.async { [weak self] in
                if let imageData = urlContents {
                    cell.backgroundImage = UIImage(data: imageData)
                    cell.label.isHidden = true
                } else {
                    let text = NSAttributedString(string: "No Image", attributes: [.font: self!.font])
                    cell.label.attributedText = text
                    cell.label.isHidden = false
                }
                cell.spinner.startAnimating()
            }
        }
    }
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(29.0))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageGalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    var flowLayout: UICollectionViewFlowLayout? {
        return imageGalleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageAspectRatio = imageDataStorage[indexPath.item].aspectRatio
        let cellWidth = ImageGalleryCollectionViewCell.defaultWidth * cellScale
        let cellHeight = cellWidth * imageAspectRatio
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

}

// MARK: - UICollectionViewDragDelegate

extension ImageGalleryCollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        session.localContext = collectionView
        indexPathsForDragging = []
        
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        
        return dragItems(at: indexPath)
    }
    
    /// Returns a drag item, holding URL of the "backgroundImage" of the cell at the given index path in the image collection view
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        guard imageGalleryCollectionView.cellForItem(at: indexPath) is ImageGalleryCollectionViewCell else { return [] }
        
        indexPathsForDragging += [indexPath]
        
        let imageURL = imageDataStorage[indexPath.item].url as NSURL
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imageURL))
        
        dragItem.localObject = imageURL
        
        return [dragItem]
    }
}

// MARK: - UICollectionViewDropDelegate

extension ImageGalleryCollectionViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        guard currentGallery != nil else { return false }
        
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        
        if isSelf {
            return session.canLoadObjects(ofClass: NSURL.self)
        } else {
            return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let section = collectionView.numberOfSections - 1
        let item = collectionView.numberOfItems(inSection: section)
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: item, section: section)
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                moveItem(item, from: sourceIndexPath, to: destinationIndexPath, withCoordinator: coordinator, inCollectionView: collectionView)
            } else {
                insertItem(item, at: destinationIndexPath, withCoordinator: coordinator, inCollectionView: collectionView)
            }
        }
    }
    
    /// This method moves a cell from 'sourceIndexPath' to 'destinationIndexPath' within the same collection view.
    ///
    /// - Parameters:
    ///   - item: The item being dragged.
    ///   - sourceIndexPath: The index path of the item in the collection view.
    ///   - destinationIndexPath: The index path in the collection view at which the content would be dropped.
    ///   - coordinator: The coordinator object, obtained from performDropWith: UICollectionViewDropDelegate method.
    ///   - collectionView: The collection view in which moving needs to be done.
    private func moveItem(_ item: UICollectionViewDropItem, from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, withCoordinator coordinator: UICollectionViewDropCoordinator, inCollectionView collectionView: UICollectionView) {
        
        if let imageURL = item.dragItem.localObject as? URL {
            let imageAspectRatio = imageDataStorage[sourceIndexPath.item].aspectRatio
            let imageData = ImageProperties(url: imageURL, aspectRatio: imageAspectRatio)
            
            collectionView.performBatchUpdates({
                imageDataStorage.remove(at: sourceIndexPath.item)
                imageDataStorage.insert(imageData, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    /// This method inserts a new cell at the 'destinationIndexPath' in the given collection view, based on an 'item' being dragged from another app.
    ///
    /// - Parameters:
    ///   - item: The item being dragged.
    ///   - destinationIndexPath: The index path in the collection view at which the content would be dropped.
    ///   - coordinator: The coordinator object, obtained from performDropWith: UICollectionViewDropDelegate method.
    ///   - collectionView: The collection view in which inserting needs to be done.
    private func insertItem(_ item: UICollectionViewDropItem, at destinationIndexPath: IndexPath, withCoordinator coordinator: UICollectionViewDropCoordinator, inCollectionView collectionView: UICollectionView) {
        
        // Instantly putting a placeholder, because the may take time
        let placeholderContext = coordinator.drop(item.dragItem,
                                                  to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: dropPlaceholderCellID))
        
        // Creating a dispatch group to start tasks concurrently and then get notified when they's finished
        let imagePropertiesGroup = DispatchGroup()
        
        // Getting image URL from the dropping item
        var dropURL: URL?
        
        imagePropertiesGroup.enter()
        item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
            if let url = provider as? URL {
                dropURL = url.imageURL
            } else {
                print("ERROR: Failed to load URL: \(error?.localizedDescription ?? "Unknown readon.")")
                placeholderContext.deletePlaceholder()
            }
            imagePropertiesGroup.leave()
        }
        
        // Getting image from the dropping item
        var dropImage: UIImage?
        
        imagePropertiesGroup.enter()
        item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
            if let image = provider as? UIImage {
                dropImage = image
            } else {
                print("ERROR: Failed to load Image: \(error?.localizedDescription ?? "Unknown reason.")")
                placeholderContext.deletePlaceholder()
            }
            imagePropertiesGroup.leave()
        }
        
        // Updating data source with image and image URL
        imagePropertiesGroup.notify(queue: DispatchQueue.main) { [weak self] in
            let dropAspectRatio = dropImage!.size.height / dropImage!.size.width
            let imageData = ImageProperties(url: dropURL!, aspectRatio: dropAspectRatio)
            
            placeholderContext.commitInsertion(dataSourceUpdates: { (insertionIndexPath) in
                self?.imageDataStorage.insert(imageData, at: insertionIndexPath.item)
            })
        }
    }
}

// MARK: - UIDropInteractionDelegate

extension ImageGalleryCollectionViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        guard let trashButtonView = trashButton.value(forKey: "view") as? UIView else {
            return UIDropProposal(operation: .cancel)
        }
        
        let currentDropPoint = session.location(in: trashButtonView)
        let isDraggingOverTrashButton = trashButtonView.bounds.contains(currentDropPoint)
        
        return UIDropProposal(operation: isDraggingOverTrashButton ? .move : .cancel)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        indexPathsForDragging.sorted(by: >).forEach { indexPath in
            imageDataStorage.remove(at: indexPath.item)
        }
        imageGalleryCollectionView.deleteItems(at: indexPathsForDragging)
    }
}

// MARK: - Gestures

extension ImageGalleryCollectionViewController {
    
    /// Adds a pinch gestion that allows the user to change scale of width of the cells in this collection view.
    private func addPinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(recognizer:)))
        
        imageGalleryCollectionView.addGestureRecognizer(pinch)
    }
    
    /// Changes scale of width of cells in image collection view.
    @objc private func pinch(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            cellScale = recognizer.scale
            flowLayout?.invalidateLayout()
        case .ended:
            if cellScale != 1.0 {
                ImageGalleryCollectionViewCell.defaultWidth *= cellScale
                cellScale = 1.0
                imageGalleryCollectionView.reloadData()
            }
        default:
            return
        }
    }
    
    /// Adds a single tap gesture to the image gallery collection view cell.
    private func addTapGesture(to cell: ImageGalleryCollectionViewCell) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(recognizer:)))
        
        cell.addGestureRecognizer(tapGesture)
    }
    
    /// Opens a new MVC, which presents the backround image of the cell.
    @objc private func tap(recognizer: UITapGestureRecognizer) {
        if let indexPath = imageGalleryCollectionView.indexPathForItem(at: recognizer.location(in: imageGalleryCollectionView)) {
            let cell = imageGalleryCollectionView.cellForItem(at: indexPath) as! ImageGalleryCollectionViewCell
            
            guard cell.backgroundImage != nil else { return }
        }
    }
}

