//
//  Card.swift
//  InMotion
//
//  Created by iosdev on 5.5.2021.
//

import UIKit

class Card: UIView {

    var cornerRadius: CGFloat = 2

    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 3
    var shadowColor: UIColor? = UIColor.black
    var shadowOpacity: Float = 0.5
    var gradientColorOne: UIColor = UIColor.white.withAlphaComponent(0.4)
    var gradientColorTwo: UIColor = UIColor.white.withAlphaComponent(0.1)
    
    
    override func layoutSubviews() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        let gradient = self.getGradient()
        layer.insertSublayer(gradient!, at: 0)
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 1)
        
    }
    
    func getGradient() -> CAGradientLayer? {
        
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width,height: self.bounds.height)
        gradientLayer.colors = [gradientColorOne.cgColor, gradientColorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) //
        
//        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
//        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        return gradientLayer
        
    }

}
