//
//  ImageDownloader.swift
//  MarvelliciousVIP
//
//  Created by Mert Gürcan on 5.01.2024.
//


import UIKit

class ImageDownloader {

    // MARK: with url
    /// Async image downloaders with URL
    static func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion: ((UIImage) -> Void)?) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                completion?(image)
            }
        }.resume()
    }

    // MARK: with string
    /// Async image downloaders with String
    static func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion: ((UIImage) -> Void)?) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, completion: completion)
    }

}
