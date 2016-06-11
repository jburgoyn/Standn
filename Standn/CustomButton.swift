//
//  CustomButton.swift
//  BrainTeaser
//
//  Created by Jonny B on 3/26/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit
import pop

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        
        didSet {
            
            setupView()
        }
    }
    
    @IBInspectable var fontColor: UIColor = UIColor.whiteColor() {
        
        didSet {
            
            self.tintColor = fontColor
        }
    }
    
    override func awakeFromNib() {
        
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        setupView()
        
      
    }
    
    func setupView() {
        
        self.layer.cornerRadius = cornerRadius
        
        // Calling animation
        self.addTarget(self, action: #selector(CustomButton.scaleToSmall), forControlEvents: .TouchDown)
        self.addTarget(self, action: "scaleToSmall", forControlEvents: .TouchDragEnter)
        self.addTarget(self, action: "scaleAnimation", forControlEvents: .TouchUpInside)
        self.addTarget(self, action: "scaleToDefault", forControlEvents: .TouchDragExit)
    }
    
    func scaleToSmall() {
        
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(0.95, 0.95))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleAnimation")
        
    }
    
    func scaleAnimation() {
        
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(3.0, 3.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 18
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
    }
    
    func scaleDefault() {
        
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1, 1))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleDefaultAnimation")
        
    }
}























