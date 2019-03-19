//
//  ImageGalleryTableViewController.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 17/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UIViewController {
    
    // MARK: - User Interface Properties
    
    lazy var imageGalleryTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - TableView Cell IDs
    
    let galleryCellID = "galleryCellID"
    let deletedGalleryCellID = "deletedGalleryCellID"
    
    // MARK: - Image Gallery Properties
    
    typealias ImageGallery = [String: [ImageProperties]]
    
    var imageGalleryData: ImageGallery {
        get {
            if let data = UserDefaults.standard.object(forKey: "ImageGallery") as? Data {
                let decoder = PropertyListDecoder()
                let imageGallery = try? decoder.decode(ImageGallery.self, from: data)
                return imageGallery ?? [:]
            } else {
                return [:]
            }
        } set {
            let encoder = PropertyListEncoder()
            let encodedData = try? encoder.encode(newValue)
            UserDefaults.standard.set(encodedData, forKey: "ImageGallery")
        }
    }
    
    var galleries: [String] = []
    var recentlyDeletedGalleries: [String] = []
    
    // MARK: Delegates
    
    weak var galleryChooserDelegate: GalleryChooserDelegate?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(newGallery))
        galleries = Array(imageGalleryData.keys)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableView()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight),
            splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardNotifications()
    }
    
    // MARK: - Actions
    
    @objc private func newGallery() {
        let newGallery = "Untitled".madeUnique(withRespectTo: Array(imageGalleryData.keys))
        galleries += [newGallery]
        imageGalleryData[newGallery] = []
        imageGalleryTableView.reloadData()
    }
    
    // MARK: - Setup Functions
    
    private func setupTableView() {
        imageGalleryTableView.delegate = self
        imageGalleryTableView.dataSource = self
        
        imageGalleryTableView.register(ImageGalleryTableViewCell.self, forCellReuseIdentifier: galleryCellID)
        imageGalleryTableView.register(ImageGalleryTableViewCell.self, forCellReuseIdentifier: deletedGalleryCellID)
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(imageGalleryTableView)
        
        imageGalleryTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        imageGalleryTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        imageGalleryTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        imageGalleryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
}

// MARK: - TableView Delegate

extension ImageGalleryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! ImageGalleryTableViewCell
        
        if cell.reuseIdentifier == deletedGalleryCellID {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! ImageGalleryTableViewCell
        
        switch cell.reuseIdentifier {
        case deletedGalleryCellID:
            let swipeAction = UIContextualAction(style: .normal, title: "Recover") { (action, sourceView, actionPerfomed) in
                
                let deletedDocument = cell.textField.text!
                let newIndexPath = IndexPath(row: self.galleries.count, section: 0)
                
                tableView.performBatchUpdates({
                    self.recentlyDeletedGalleries.remove(at: indexPath.row)
                    self.galleries += [deletedDocument]
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                    
                    tableView.reloadData()
                })
            }
            swipeAction.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [swipeAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = true
            
            return swipeConfiguration
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - TableView DataSource

extension ImageGalleryTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return galleries.count
        case 1:
            return recentlyDeletedGalleries.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: deletedGalleryCellID, for: indexPath) as! ImageGalleryTableViewCell
            
            cell.accessoryType = .detailDisclosureButton
            cell.textField.text = recentlyDeletedGalleries[indexPath.row]
            cell.parentViewController = self
            cell.addTapGestures()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: galleryCellID, for: indexPath) as! ImageGalleryTableViewCell
            
            cell.accessoryType = .detailDisclosureButton
            cell.textField.text = galleries[indexPath.row]
            cell.parentViewController = self
            cell.addTapGestures()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0, galleries.count > 0 {
            return "Galleries"
        } else if section == 1, recentlyDeletedGalleries.count > 0 {
            return "Recently Deleted Galleries"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ImageGalleryTableViewCell
        
        if editingStyle == .delete {
            switch cell.reuseIdentifier {
            case galleryCellID:
                let deletedDocument = cell.textField.text!
                let newIndexPath = IndexPath(row: recentlyDeletedGalleries.count, section: 1)
                
                tableView.performBatchUpdates({
                    galleries.remove(at: indexPath.row)
                    recentlyDeletedGalleries += [deletedDocument]
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                })
            case deletedGalleryCellID:
                let deletedDocument = cell.textField.text!
                recentlyDeletedGalleries.remove(at: indexPath.row)
                imageGalleryData[deletedDocument] = nil
                tableView.deleteRows(at: [indexPath], with: .fade)
            default:
                break
            }
        }
    }
}

// MARK: - GalleryChooserDelegate

extension ImageGalleryTableViewController: CellChooserDelegate {
    func didChooseCell(sender: ImageGalleryTableViewCell) {
        
        let currentGallery = sender.textField.text!
        
        galleryChooserDelegate?.didChooseGallery(currentGallery: currentGallery, imageDataStorage: imageGalleryData[currentGallery]!)
        splitViewController?.toggleMasterView()
    }
    
}

// MARK: - Notifications

extension ImageGalleryTableViewController {
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: self)
    }
    
    @objc private func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        imageGalleryTableView.contentInset = contentInsets
        imageGalleryTableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        imageGalleryTableView.contentInset = contentInsets
        imageGalleryTableView.scrollIndicatorInsets = contentInsets
    }
}

