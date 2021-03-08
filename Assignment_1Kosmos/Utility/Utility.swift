//
//  Utility.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 23/07/20.
//  Copyright © 2020 Utkarsh Sehgal. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

/// Custom class for implemnetation of the commonly used functions
class Utility {
    
    /// Shows Loader
    func showLoader(message: String) {
        DispatchQueue.main.async {
            ActivityLoader.shared.show(message: message)
        }
    }
    
    /// Dismiss Loader
    func dismissLoader() {
        DispatchQueue.main.async {
            ActivityLoader.shared.hide()
        }
    }
    
    /// Get the corresponding string for the key from the config file
    /// - Parameter key: Key for which the value is to be provided
    /// - Returns: Value string
    static func infoForKey(_ key: String) -> String? {
           return (Bundle.main.infoDictionary?[key] as? String)?
               .replacingOccurrences(of: "\\", with: "")
    }
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? UIImage()
    }

}

