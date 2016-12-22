//
//  FaceView.swift
//  Facelt
//
//  Created by 李天培 on 2016/10/31.
//  Copyright © 2016年 lee. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    // MARK: - properties
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var mouthCurvature: Double = -1.0 { didSet { setNeedsDisplay() } }// 1 full smile, -1 full frown
    @IBInspectable
    var eyesOpen: Bool = true { didSet { leftEye.eyesOpen = eyesOpen; rightEye.eyesOpen = eyesOpen } }
    @IBInspectable
    var eyeBrowTilt: Double = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay(); leftEye.lineWidth = lineWidth; rightEye.lineWidth = lineWidth } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay(); leftEye.color = color; rightEye.color = color } }
    
    func changeScale(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    private enum Eye {
        case left
        case right
    }
    
    // MARK: - Path For Face
    
    private func pathForCircleCentered(AtPoint center: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: 0.0,
                                endAngle: CGFloat(2 * M_PI),
                                clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    private func getEyeCenter(_ eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .left: eyeCenter.x -= eyeOffset
        case .right: eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        self.addSubview(eye)
        return eye
    }

    private func position(eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.SkullRadiusToEyeRadius * 2
        eye.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        position(eye: leftEye, center: getEyeCenter(.left))
        position(eye: rightEye, center: getEyeCenter(.right))
    }
    
//    private func pathForEye(_ eye: Eye) -> UIBezierPath {
//        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
//        let eyeCenter = getEyeCenter(eye)
//        if eyesOpen {
//            return pathForCircleCentered(AtPoint: eyeCenter, withRadius: eyeRadius)
//        } else {
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
//            path.lineWidth = lineWidth
//            return path
//        }
//    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2,
                               y: skullCenter.y + mouthOffset,
                               width: mouthWidth, height: mouthHeight)
        
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthWidth / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthWidth / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForBrow(ForEye eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .left: tilt *= -1.0
        case .right: break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        color.set()
        pathForCircleCentered(AtPoint: skullCenter, withRadius: skullRadius).stroke()
//        pathForEye(.left).stroke()
//        pathForEye(.right).stroke()
        pathForMouth().stroke()
        pathForBrow(ForEye: .left).stroke()
        pathForBrow(ForEye: .right).stroke()
    }
    
    
}
