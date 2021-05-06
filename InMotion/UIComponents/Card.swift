//
//  Card.swift
//  InMotion
//
//  Created by Michael Carter on 5.5.2021.
//

import UIKit

// Custom view that is designed to look like a card with shadow and gradient background
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
        
        // Adds shadow
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        let gradient = self.getGradient()
        layer.insertSublayer(gradient!, at: 0)
        
        // Adds a blur effect - attempt at glassmorphism
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 1)
        
    }
    
    // Creates a gratient object layer
    func getGradient() -> CAGradientLayer? {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width,height: self.bounds.height)
        gradientLayer.colors = [gradientColorOne.cgColor, gradientColorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) //
        
        return gradientLayer
        
    }
    
}
