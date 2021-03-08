//
//  UIView.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 05/03/21.
//

import Foundation
import UIKit

extension UIView {
    //provide rounded corners to the UIView from any of the provided sides
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
    
    /* @brief: Method to draw shadow on view.
     * @param: view
     * @param: color
     * @param: opacity, shadow opacity
     * @param: offSet, shadow offset
     * @param: radius, shadowRadius
     * @param: color
     */
    func dropShadow(color: UIColor, opacity: Float) {
        //layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 5
    }
    
    /// Create a view with dashed border
    /// - Parameters:
    ///   - pattern: dashed pattern
    ///   - radius: radius of the dashed border
    ///   - color: color for the dashed border
    /// - Returns: shape layer for the resulatant view with dashed border
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()

        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

        layer.addSublayer(borderLayer)
        return borderLayer
    }
}
