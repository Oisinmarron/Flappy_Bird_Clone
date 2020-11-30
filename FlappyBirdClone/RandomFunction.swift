//
//  RandomFunction.swift
//  FlappyBirdClone
//
//  Created by Oisin Marron on 30/11/2020.
//  Copyright © 2020 Oisin Marron. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    static func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return CGFloat.random() * (max-min) + min
    }
}
