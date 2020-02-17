//
//  AlertHelper.swift
//  SimpleMovies
//
//  Created by Eduardo Sanches Bocato on 16/02/20.
//  Copyright © 2020 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

enum AlertHelper {
    
    static func presentAlert(
        from controller: UIViewController,
        title: String? = nil,
        message: String,
        rightAction: UIAlertAction,
        completionHandler: (() -> Void)? = nil
    ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(rightAction)
        
        DispatchQueue.main.async {
            controller.present(alert, animated: true, completion: completionHandler)
        }
        
    }
    
    static func presentOkAlert(
        from controller: UIViewController,
        title: String? = nil,
        message: String,
        completionHandler: (() -> Void)? = nil
    ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            controller.present(alert, animated: true, completion: completionHandler)
        }
    }
    
}
