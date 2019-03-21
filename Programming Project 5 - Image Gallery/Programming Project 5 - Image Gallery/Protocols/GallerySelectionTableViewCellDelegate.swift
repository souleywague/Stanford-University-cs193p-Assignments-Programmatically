//
//  GallerySelectionTableViewCellDelegate.swift
//  Programming Project 5 - Image Gallery
//
//  Created by Souley on 21/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

protocol  GallerySelectionTableViewCellDelegate: AnyObject {
    func titleDidChange(_ title: String, in cell: UITableViewCell)
}
