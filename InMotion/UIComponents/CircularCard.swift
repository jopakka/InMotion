//
//  CircularCard.swift
//  InMotion
//
//  Created by Michael Carter on 6.5.2021.
//

import UIKit

// Card view that only has shadow associated with it
class CircularCard: UIView {
    var cornerRadius: CGFloat = 2
    
    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 3
    var shadowColor: UIColor? = UIColor.black
    var shadowOpacity: Float = 0.5
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}
