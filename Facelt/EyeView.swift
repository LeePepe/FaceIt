//
//  EyeView.swift
//  Facelt
//
//  Created by 李天培 on 2016/12/21.
//  Copyright © 2016年 lee. All rights reserved.
//

import UIKit

class EyeView: UIView {
    
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    private var _eyesOpen: Bool = true { didSet { setNeedsDisplay() } }
    
    var eyesOpen: Bool {
        get {
            return _eyesOpen
        }
        set {
            UIView.transition(
                with: self,
                duration: 0.1,
                options: [.transitionFlipFromTop, ],
                animations: {
                    self._eyesOpen = newValue
            },
                completion: nil)
        }
    }
    
    override func draw(_ rect: CGRect) {
        var path: UIBezierPath
        if eyesOpen {
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2))
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        }
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
}
