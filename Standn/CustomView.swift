//
//  CustomView.swift
//  BrainTeaser
//
//  Created by Jonny B on 5/1/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit
import pop

@IBDesignable
class CustomView: UIImageView {
    
    
    override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        scaleAnimation()
        
    }
    
    
    func scaleAnimation() {
        
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(3.0, 3.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 18
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
        print("got to animation")
        
    }
    
}
