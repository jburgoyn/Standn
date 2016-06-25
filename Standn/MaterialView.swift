//
//  Extensions.swift
//  BrainTeaser
//
//  Created by Jonny B on 3/26/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class MaterialView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}