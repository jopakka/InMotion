//
//  StyledButton.swift
//  InMotion
//
//  Created by iosdev on 4.5.2021.
//

import UIKit

class StyledButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let color = UIColor.blue
        let disabledColor = color.withAlphaComponent(0.3)

        let bthWidth = 200
        let btnHeight = 60
        
        self.frame.size = CGSize(width: bthWidth, height: btnHeight)
        self.frame.origin = CGPoint(x: (((superview?.frame.width)! / 2) - (self.frame.width / 2)), y: self.frame.origin.y)
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        
        self.layer.borderColor = color.cgColor
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(disabledColor, for: .disabled)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.setTitle(self.titleLabel?.text?.capitalized, for: .normal)
        
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.link.cgColor,
            UIColor.blue.cgColor
        ]
        gradient.locations = [0, 0.7, 1]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)

        
        self.contentEdgeInsets.bottom = 4
        
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        

    }
    
}
