//
//  UIImageViewExtension.swift
//  SimpleMovies
//
//  Created by Eduardo Sanches Bocato on 16/02/20.
//  Copyright © 2020 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

extension UIImageView {
    
    @discardableResult
    func setImageFromURL(_ urlString: String, errorImage: UIImage? = .noImage) -> URLSessionDataTask? {
        
        guard let url = URL(string: urlString) else {
            self.image = errorImage
            return nil
        }
        
        return Network.shared.getData(from: url) { [weak self] result in
            guard
                let data = try? result.get(),
                let remoteImage = UIImage(data: data)
            else {
                DispatchQueue.main.async { self?.image = errorImage }
                return
            }
            DispatchQueue.main.async { self?.image = remoteImage }
        }
        
    }
    
}
