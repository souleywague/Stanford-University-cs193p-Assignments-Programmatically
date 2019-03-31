//
//  ImageRequestManager.swift
//  Programming Project 6 - Persistant Image Gallery
//
//  Created by Souley on 31/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

/// Class in charge of requesting the provided images from the internet and cache them.
class ImageRequestManager {
    
    // MARK: - Properties
    
    /// The session used to make each data task;
    private(set) lazy var session: URLSession = {
        let cache = URLCache(memoryCapacity: 4 * 1024 * 1024,
                             diskCapacity: 80 * 1024 * 1024,
                             diskPath: nil)
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        return URLSession(configuration: configuration,
                          delegate: nil,
                          delegateQueue: nil)
    }()
    
    // MARK: - Methods
    
    /// Requests an image at the provided URL.
    func request(at url: URL, withCompletionHandler completion: @escaping (Data) -> (),
                 andErrorHandler onError: @escaping (Error?, URLResponse?) -> ()) {
        let task = session.dataTask(with: url) { (data, response, transportError) in
            guard transportError == nil, let data = data else {
                onError(transportError, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                ["image/jpeg", "image/png"].contains(httpResponse.mimeType) else {
                onError(nil, response)
                return
            }
            completion(data)
        }
        task.resume()
    }
}
