//
//  ImageGalleryDocumentBrowserViewController.swift
//  Programming Project 6 - Persistant Image Gallery
//
//  Created by Souley on 31/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ImageGalleryDocumentBrowserViewController: UIDocumentBrowserViewController {

    // MARK: - Properties
    
    /// The template file's url.
    var templateURL: URL?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        allowsPickingMultipleItems = false
        browserUserInterfaceStyle = .light
        
        allowsDocumentCreation = false
        
        // Only allows the creation of documents when running on ipad devices.
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            // Creates the template file:
            let fileManager = FileManager.default
            
            templateURL = try? fileManager.url(for: .applicationSupportDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: true).appendingPathComponent("untitled.imagegallery")
            
            if let templateURL = templateURL {
                allowsDocumentCreation = fileManager.createFile(atPath: templateURL.path,
                                                                contents: Data())
                
                // Writes an empty image gallery into the template file:
                
            }
        }
    }
    
    
    // MARK: - Document Presentation
    
    /// Presents the document stored at the provided url.
    func presentDocument(at documentURL: URL) {
        // TODO: Present Gallery Display View Controller
    }
}

// MARK: - UIDocumentBrowserViewControllerDelegate

extension ImageGalleryDocumentBrowserViewController: UIDocumentBrowserViewControllerDelegate {
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(templateURL, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        presentWarningWith(title: "Error", message: "The document can't be opened")
    }
}
