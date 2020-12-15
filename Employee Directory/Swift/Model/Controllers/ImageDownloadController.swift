//
//  ImageDownloadController.swift
//  Employee Directory
//
//  Created by Brian Papa on 6/3/20.
//  Copyright © 2020 Brian Papa. All rights reserved.
//

import UIKit

enum ImageDownloadError: Error {
    // There an I/O issue with the `Library/Caches` directory
    case filesystemError
    // Data was not returned by the server
    case noData
    // The response data could be decoded into an image
    case noImage
}

class ImageDownloadController {
    /// Retrieves a cached image for the specified `URL`, or downloads it from API
    /// - Parameters:
    ///   - url: the `URL` of the image
    ///   - completion: a single argument closure with a `Result` containing the image on sucess
    func createCachedImageOrDownload(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let cachedImageURL = url.cachedFileURL else {
            completion(.failure(ImageDownloadError.filesystemError))
            return
        }
        if let cachedImage = UIImage(contentsOfFile: cachedImageURL.path) {
            completion(.success(cachedImage))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(ImageDownloadError.noData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(ImageDownloadError.noImage))
                return
            }
            
            do {
                try data.write(to: cachedImageURL)
            } catch {
                completion(.failure(error))
            }
            
            completion(.success(image))
        }.resume()
    }
}
