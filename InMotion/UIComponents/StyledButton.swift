//
//  StyledButton.swift
//  InMotion
//
//  Created by Michael Carter on 4.5.2021.
//

import UIKit

// Custom button used throughout the application

class StyledButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let color = UIColor.blue
        let disabledColor = color.withAlphaComponent(0.3)
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(disabledColor, for: .disabled)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.setTitle(self.titleLabel?.text?.capitalized, for: .normal)
        self.layer.cornerRadius = 12.0
    }
    
    // Adds shadow to the button boarder
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.link.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
}
