//
//  UIImageView+RM.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-07.
//

import UIKit

extension UIImageView {
    
    /// Presenting the placeHolderImage before the image is loaded from the given url
    func loadImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, placeHolderImage: UIImage?) {
        contentMode = mode
        if let placeHolderImage = placeHolderImage {
            image = placeHolderImage
        }
        
        let imageRequest = URLRequest(url: url)
        URLSession.shared.request(with: imageRequest) { result in
            if case .success(let data) = result,
               let image = UIImage(data: data) {
                
                // update the imageView in main queue only when a valid image is loaded from url
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            }
        }
    }
}
