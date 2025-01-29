//
//  UIImage+URLLoadImg.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/29/25.
//

import Foundation
import UIKit

extension UIImage {
    // Load an image from a URL
    static func load(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Start an async task to download the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            // If the data is valid and there's no error, create the image
            if let data = data, error == nil {
                let image = UIImage(data: data)
                // Call the completion handler on the main thread
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
