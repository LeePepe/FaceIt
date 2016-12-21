//
//  FacialExpression.swift
//  Facelt
//
//  Created by 李天培 on 16/5/23.
//  Copyright © 2016年 lee. All rights reserved.
//

import Foundation

struct FacialExpression {
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
    
    enum Eyes: Int {
        case Open
        case Closed
        case Squinting
    }
    
    enum  EyeBrows: Int {
        case Relaxed
        case Normal
        case Furrowed
        
        func  moreRelaxedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        func moreFurrowed() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int {
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
}