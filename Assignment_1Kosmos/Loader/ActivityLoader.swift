//
//  ActivityLoader.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 05/03/21.
//


import Foundation
import UIKit

class ActivityLoader: NSObject {
    /// shared instance of the loader
    static let shared = ActivityLoader()
    /// container view containing the loader
    var containerView: UIView!
    /// loader
    var activityIndicator: UIActivityIndicatorView?
    /// activity label
    var activityLabel: UILabel!
    
    //MARK: Initializer(s)
    
    /// private initializer to add loader
    private override init() {
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenBounds.screen_Width, height:  Constants.ScreenBounds.screen_Height))
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator?.center = containerView.center
        activityLabel = UILabel(frame: CGRect(x: 10, y: (activityIndicator?.frame.maxY)!+10, width: Constants.ScreenBounds.screen_Width-20, height: 50))
        activityLabel.textColor = .white
        activityLabel.textAlignment = .center
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        containerView.addSubview(activityIndicator!)
        containerView.addSubview(activityLabel)
    }
    
    /// func to show the loader
    func show(message: String) {
        if let activityIndicator = activityIndicator {
            if let activityLabel = activityLabel {
                activityLabel.text = message
            }
            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(containerView)
            activityIndicator.startAnimating()
        }
    }
    
    /// func to hide the loader
    func hide() {
        activityIndicator?.stopAnimating()
        containerView?.removeFromSuperview()
    }
}

