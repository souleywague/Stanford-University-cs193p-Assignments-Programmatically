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
    
    private let documentCellID = "documentCellID"
    private let deletedCellID = "deletedCellID"
    
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
    
    var documents: [String] = []
    var recentlyDeletedDocuments: [String] = []
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(newDocument))
        
        documents = Array(imageGalleryData.keys)
        
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
    
    // MARK: - Actions
    
    @objc private func newDocument() {
        let newDocument = "Untitled".madeUnique(withRespectTo: Array(imageGalleryData.keys))
        documents += [newDocument]
        imageGalleryData[newDocument] = []
        imageGalleryTableView.reloadData()
    }
    
    // MARK: - Setup Functions
    
    private func setupTableView() {
        imageGalleryTableView.delegate = self
        imageGalleryTableView.dataSource = self
        imageGalleryTableView.register(ImageGalleryTableViewCell.self, forCellReuseIdentifier: documentCellID)
        imageGalleryTableView.register(ImageGalleryTableViewCell.self, forCellReuseIdentifier: deletedCellID)
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
        
        if cell.reuseIdentifier == deletedCellID {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! ImageGalleryTableViewCell
        
        switch cell.reuseIdentifier {
        case deletedCellID:
            let swipeAction = UIContextualAction(style: .normal, title: "Recover") { (action, sourceView, actionPerfomed) in
                
                let deletedDocument = cell.textField.text!
                let newIndexPath = IndexPath(row: self.documents.count, section: 0)
                
                tableView.performBatchUpdates({
                    self.recentlyDeletedDocuments.remove(at: indexPath.row)
                    self.documents += [deletedDocument]
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                    
                    tableView.reloadData()
                })
            }
            swipeAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [swipeAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = true
            
            return swipeConfiguration
        default:
            return nil
        }
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
            return documents.count
        case 1:
            return recentlyDeletedDocuments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: deletedCellID, for: indexPath) as! ImageGalleryTableViewCell
            
            cell.textField.text = recentlyDeletedDocuments[indexPath.row]
            cell.parentViewController = self
            cell.addTapGestures()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: documentCellID, for: indexPath) as! ImageGalleryTableViewCell
            
            cell.textField.text = documents[indexPath.row]
            cell.parentViewController = self
            cell.addTapGestures()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0, documents.count > 0 {
            return "Documents"
        } else if section == 1, recentlyDeletedDocuments.count > 0 {
            return "Recently Deleted"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ImageGalleryTableViewCell
        
        if editingStyle == .delete {
            switch cell.reuseIdentifier {
            case documentCellID:
                let deletedDocument = cell.textField.text!
                let newIndexPath = IndexPath(row: recentlyDeletedDocuments.count, section: 1)
                
                tableView.performBatchUpdates({
                    documents.remove(at: indexPath.row)
                    recentlyDeletedDocuments += [deletedDocument]
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                })
            case deletedCellID:
                let deletedDocument = cell.textField.text!
                recentlyDeletedDocuments.remove(at: indexPath.row)
                imageGalleryData[deletedDocument] = nil
                tableView.deleteRows(at: [indexPath], with: .fade)
            default:
                break
            }
        }
    }
}
