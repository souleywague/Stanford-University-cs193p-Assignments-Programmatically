//
//  ImageGalleryTableViewCell.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 17/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell {

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private var previousTitle: String?
    
    // MARK: - Parent View Controllers
    
    weak var parentViewController: ImageGalleryTableViewController!
    
    // MARK: - Setup Functions
    
    private func setupLayout() {
        contentView.addSubview(cellView)
        
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}

// MARK: - Extensions

extension ImageGalleryTableViewCell {
    
    func addTapGestures() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap(recognizer:)))
        
        singleTapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(recognizer:)))
        
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc func singleTap(recognizer: UITapGestureRecognizer) {
        disableAnyEnabledTextField()
        
        let indexPath = parentViewController.imageGalleryTableView.indexPath(for: self)
        parentViewController.imageGalleryTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        // TODO: Show image collection
    }
    
    private func disableAnyEnabledTextField() {
        parentViewController.imageGalleryTableView.visibleCells.forEach { cell in
            if let cell = cell as? ImageGalleryTableViewCell {
                cell.textField.isEnabled = false
                cell.textField.resignFirstResponder()
            }
        }
    }
    
    @objc func doubleTap(recognizer: UITapGestureRecognizer) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension ImageGalleryTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        previousTitle = textField.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text != previousTitle else { return }
        updateTextField()
        updateTableView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func updateTextField() {
        let allDocuments = Array(parentViewController.imageGalleryData.keys)
        textField.text = textField.text!.madeUnique(withRespectTo: allDocuments)
        textField.isEnabled = false
    }
    
    private func updateTableView() {
        let newTitle = textField.text!
        let row = parentViewController.imageGalleryTableView.indexPath(for: self)!.row
        let imageCollection = parentViewController.imageGalleryData[previousTitle!]
        
        parentViewController.imageGalleryTableView.performBatchUpdates({
            if reuseIdentifier == "deletedCellID" {
                parentViewController.recentlyDeletedDocuments.remove(at: row)
                parentViewController.recentlyDeletedDocuments.insert(newTitle, at: row)
            } else {
                parentViewController.documents.remove(at: row)
                parentViewController.documents.insert(newTitle, at: row)
            }
            parentViewController.imageGalleryData.removeValue(forKey: previousTitle!)
            parentViewController.imageGalleryData[newTitle] = imageCollection
        })
    }
}
