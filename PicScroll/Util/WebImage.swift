//
//  WebImage.swift
//  PicScroll
//
//  Created by Dhruv Govani on 16/04/24.
//

import UIKit

extension UIImageView {
    
    private static let imageCache = NSCache<NSURL, UIImage>()
    
    private static var cacheDirectory: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        return cacheDirectory
    }
    
    /// Load an image asynchronously from web.
    /// - Parameters:
    ///   - url: Image Download URL
    ///   - placeholder: Placeholder image to show until image is being download
    ///   - compeletion: block which tells if download was success or failed
    func loadImage(from url: URL, placeholder: UIImage? = nil, compeletion : @escaping ((Bool) -> ())) {
        
        // set image if available in memory cache
        if let cachedImage = UIImageView.imageCache.object(forKey: url as NSURL) {
            self.image = cachedImage
            compeletion(true)
            return
        }
         
        self.image = placeholder
        
        let request = URLRequest(url: url)
        
        // set image from disk cache and loading into memory cache
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            self.image = image
            compeletion(true)
            UIImageView.imageCache.setObject(image, forKey: url as NSURL)
            return
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        let session = URLSession(configuration: config)
        
        // Download image asynchronously
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                compeletion(false)
                return
            }
            
            // Cache downloaded image in memory
            UIImageView.imageCache.setObject(image, forKey: url as NSURL)
            
            
            DispatchQueue.main.async {
                self.image = image // Update image
            }
            
            // Caching image to disk
            let cachedResponse = CachedURLResponse(response: response ?? URLResponse(), data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            
            // Creating cache directory if it doesn't exist
            if !FileManager.default.fileExists(atPath: UIImageView.cacheDirectory.path) {
                do {
                    try FileManager.default.createDirectory(at: UIImageView.cacheDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    compeletion(false)
                    print("Failed to create cache directory: \(error)")
                }
            }
            
            // Write image data to disk cache to created directory to persist afterwards
            let cacheFile = UIImageView.cacheDirectory.appendingPathComponent(url.lastPathComponent)
            do {
                try data.write(to: cacheFile)
            } catch {
                compeletion(false)
                print("Failed to write image data to disk cache: \(error)")
            }
        }
        
        task.resume()
    }
}
