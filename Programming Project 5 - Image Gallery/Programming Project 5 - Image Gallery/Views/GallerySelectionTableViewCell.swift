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
    
    private lazy var cellView: UIView = {
        let cellView = UIView()
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        return cellView
    }()
    
    /// The text field used to edit the title's row.
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        
        textField.returnKeyType = .done
        
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
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overriden Properties
    
    /// Change of this property to enable/disable the internal textField.
    override var isEditing: Bool {
        didSet {
            titleTextField.isEnabled = isEditing
            
            if isEditing == true {
                titleTextField.becomeFirstResponder()
            } else {
                titleTextField.resignFirstResponder()
            }
        }
    }
    
    // MARK: - Methods
    
    private func endEditing() {
        isEditing = false
    }
    
    // MARK: - Actions
    
    @objc func titleDidChange(_ sender: UITextField) {
        guard let title = sender.text, title != "" else { return }
        
        delegate?.titleDidChange(sender.text ?? "", in: self)
    }

    // MARK: - Setup Functions
    
    private func setupTextField() {
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(titleDidChange(_:)), for: .editingDidEnd)
    }
    
    private func setupLayout() {
        contentView.addSubview(cellView)
        cellView.addSubview(titleTextField)
        
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleTextField.topAnchor.constraint(equalTo: cellView.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 15).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: cellView.trailingAnchor).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: cellView.bottomAnchor).isActive = true
    }
}

// MARK: - UITextFieldDelegate

extension GallerySelectionTableViewCell: UITextFieldDelegate {
    override func becomeFirstResponder() -> Bool {
        return isEditing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        
        return true
    }
    
}
