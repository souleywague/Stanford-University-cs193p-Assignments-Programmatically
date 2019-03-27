//
//  GallerySelectionTableViewCell.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 21/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class GallerySelectionTableViewCell: UITableViewCell {

    // MARK: - Cell View Properties
    
    /// The text field used to edit the title's row.
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        
        textField.returnKeyType = .done
        
        textField.isEnabled = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    // MARK: - Properties
    
    /// The row's title.
    var title: String {
        set {
            titleTextField.text = newValue
        } get {
            return titleTextField.text ?? ""
        }
    }
    
    // MARK: - Delegates
    
    /// The cell's delegate
    weak var delegate: GallerySelectionTableViewCellDelegate?
    
    // MARK: - Parent View Controller
    
    weak var parentViewController: GallerySelectionTableViewController!
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        setupTextField()
        addTapGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    /// Disables any enabled text fields of the cells in current table view.
    private func disableAnyEnabledTextField() {
        parentViewController.gallerySelectionTableView.visibleCells.forEach { cell in
            if let cell = cell as? GallerySelectionTableViewCell {
                cell.titleTextField.isEnabled = false
                cell.titleTextField.resignFirstResponder()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func titleDidChange(_ sender: UITextField) {
        guard let title = sender.text, title != "" else { return }
        
        delegate?.titleDidChange(sender.text ?? "", in: self)
    }

    // MARK: - Gestures
    
    @objc func singleTap(recognizer: UITapGestureRecognizer) {
        disableAnyEnabledTextField()
        
        let indexPath = parentViewController.gallerySelectionTableView.indexPath(for: self)
        
        parentViewController.gallerySelectionTableView.selectRow(at: indexPath,
                                                                 animated: true,
                                                                 scrollPosition: .none)
    }
    
    @objc func doubleTap(recognizer: UITapGestureRecognizer) {
        titleTextField.isEnabled = true
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: - Setup Functions
    
    func addTapGestures() {
        let singleTapGesture = UITapGestureRecognizer(target: self,
                                                      action: #selector(singleTap(recognizer:)))
        
        singleTapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self,
                                                      action: #selector(doubleTap(recognizer:)))
        
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    private func setupTextField() {
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(titleDidChange(_:)), for: .editingDidEnd)
    }
    
    private func setupLayout() {
        contentView.addSubview(titleTextField)
        
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

// MARK: - UITextFieldDelegate

extension GallerySelectionTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        
        return true
    }
    
}
