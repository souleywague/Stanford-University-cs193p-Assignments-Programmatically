//
//  GallerySelectionTableViewController.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 21/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class GallerySelectionTableViewController: UIViewController {
    
    // MARK: - User Interface Properties
    
    lazy var gallerySelectionTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Properties
    
    /// The gallery cell id.
    private let galleryCellID = "galleryCellID"
    
    /// The store containing the user's galleries.
    var galleriesStore: ImageGalleryStore? {
        didSet {
            gallerySelectionTableView.reloadData()
        }
    }
    
    /// The table view's data.
    private var galleriesSource: [[ImageGallery]] {
        get {
            if let store = galleriesStore {
                return [store.galleries, store.deletedGalleries]
            } else {
                return []
            }
        }
    }
    
    /// The split's view detail controller, if set.
    private var detailController: GalleryDisplayCollectionViewController? {
        return splitViewController?.viewControllers.last?.contents as? GalleryDisplayCollectionViewController
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTableView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped(_:)))
        
        if let selectedGallery = detailController?.gallery {
            if let index = galleriesStore?.galleries.firstIndex(of: selectedGallery) {
                let selectionIndexPath = IndexPath(row: index, section: Section.available.rawValue)
                gallerySelectionTableView.selectRow(at: selectionIndexPath,
                                                    animated: true,
                                                    scrollPosition: .none)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeNotifications()
    }
    
    // MARK: - Methods
    
    /// Selects the first gallery.
    private func selectFirstGallery() {
        let availableSection = Section.available.rawValue
        
        guard !galleriesSource[availableSection].isEmpty else { return }
        
        let selectionIndexPath = IndexPath(row: 0, section: availableSection)
        
        gallerySelectionTableView.selectRow(at: selectionIndexPath,
                                            animated: true,
                                            scrollPosition: UITableView.ScrollPosition.top)
        
//        let selectedCell = gallerySelectionTableView.cellForRow(at: selectionIndexPath)
        
        // TODO: Perform Navigation
    }
    
    private func getGallery(at indexPath: IndexPath) -> ImageGallery? {
        return galleriesSource[indexPath.section][indexPath.row]
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        galleriesStore?.addNewGallery()
        gallerySelectionTableView.reloadData()
    }
    
    @objc private func didDoubleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = gallerySelectionTableView.indexPathForRow(at: sender.location(in: gallerySelectionTableView)) {
            if let cell = gallerySelectionTableView.cellForRow(at: indexPath) as? GallerySelectionTableViewCell {
                cell.isEditing = true
            }
        }
    }
    
    // MARK: - Setup Functions
    
    private func setupTableView() {
        gallerySelectionTableView.delegate = self
        gallerySelectionTableView.dataSource = self
        
        gallerySelectionTableView.register(GallerySelectionTableViewCell.self, forCellReuseIdentifier: galleryCellID)
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(gallerySelectionTableView)
        
        gallerySelectionTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        gallerySelectionTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        gallerySelectionTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        gallerySelectionTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    private func setupNotifications() {
        registerForGalleryNotifications()
        registerForKeyboardNotifications()
    }
    
    private func removeNotifications() {
        removeGalleryNotifications()
        removeKeyboardNotifications()
    }
}

// MARK: - UITableViewDataSource

extension GallerySelectionTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return galleriesSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleriesSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: galleryCellID,
                                                 for: indexPath) as! GallerySelectionTableViewCell
        
        let gallery = galleriesSource[indexPath.section][indexPath.row]
        
        cell.delegate = self
        
        cell.title = gallery.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let deletedGallery = getGallery(at: indexPath) {
                self.galleriesStore?.removeGallery(deletedGallery)
                tableView.reloadData()
            }
            fallthrough
        default:
            break
        }
    }
    
}

// MARK: - TableViewDelegate

extension GallerySelectionTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = Section(rawValue: indexPath.section)
        
        return section == .available
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = Section(rawValue: indexPath.section)
        
        if section == .deleted {
            var actions = [UIContextualAction]()
            
            let recoverAction = UIContextualAction(style: .normal, title: "Recover") { (action, view, _) in
                if let deletedGallery = self.getGallery(at: indexPath) {
                    self.galleriesStore?.recoverGallery(deletedGallery)
                    self.gallerySelectionTableView.reloadData()
                }
            }
            
            actions.append(recoverAction)
            
            return UISwipeActionsConfiguration(actions: actions)
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - GallerySelectionTableViewCellDelegate

extension GallerySelectionTableViewController: GallerySelectionTableViewCellDelegate {
    func titleDidChange(_ title: String, in cell: UITableViewCell) {
        if let indexPath = gallerySelectionTableView.indexPath(for: cell) {
            if var gallery = getGallery(at: indexPath) {
                gallery.title = title
                galleriesStore?.updateGallery(gallery)
                gallerySelectionTableView.reloadData()
            }
        }
    }
}

// MARK: - Notifications

extension GallerySelectionTableViewController {
    
    // MARK: - Gallery Notifications
    
    private func registerForGalleryNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDeleteNotification(_:)),
                                               name: Notification.Name.galleryDeleted,
                                               object: nil)
    }
    
    private func removeGalleryNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.galleryDeleted, object: self)
    }
    
    @objc private func didReceiveDeleteNotification(_ notification: Notification) {
        if let deletedGallery = notification.userInfo?[Notification.Name.galleryDeleted] as? ImageGallery {
            if detailController?.gallery == deletedGallery {
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (_) in
                    self.selectFirstGallery()
                }
            }
        }
    }
    
    // MARK: - Keyboard Notifications
    
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
        
        gallerySelectionTableView.contentInset = contentInsets
        gallerySelectionTableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        gallerySelectionTableView.contentInset = contentInsets
        gallerySelectionTableView.scrollIndicatorInsets = contentInsets
    }
    
}

// MARK: - Section Enumeration

extension GallerySelectionTableViewController {
    private enum Section: Int {
        case available = 0
        case deleted
    }
}
