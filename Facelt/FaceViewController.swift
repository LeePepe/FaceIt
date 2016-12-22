//
//  FaceViewController.swift
//  Facelt
//
//  Created by 李天培 on 2016/10/31.
//  Copyright © 2016年 lee. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }
    // MARK: - IBOutlet
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(_:))
            ))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness
                ))
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness
                ))
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            
            
            updateUI()
        }
    }
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI / 6)
        static let ShakeDuration = 0.5
    }
    
    @IBAction func headshake(_ sender: UITapGestureRecognizer) {
        UIView.animate(
            withDuration: Animation.ShakeDuration,
            animations: {
                self.faceView.transform = self.faceView.transform.rotated(by: Animation.ShakeAngle)
        },
            completion: { (finished) in
                if finished {
                    UIView.animate(
                        withDuration: Animation.ShakeDuration,
                        animations: {
                            self.faceView.transform = self.faceView.transform.rotated(by: -Animation.ShakeAngle * 2)
                    },
                        completion: { (finished) in
                            if finished {
                                UIView.animate(
                                    withDuration: Animation.ShakeDuration,
                                    animations: {
                                        self.faceView.transform = self.faceView.transform.rotated(by: Animation.ShakeAngle)
                                },
                                    completion: nil
                                )
                            }
                    })
                }
        })
    }
    
    @IBAction func toggleEyes(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    //
    
    private var mouthCurvatures = [
        FacialExpression.Mouth.Frown: -1.0,
        .Grin: 0.5,
        .Smile: 1.0,
        .Smirk: -0.5,
        .Neutral: 0.0
    ]
    
    private var eyeBrowTilt = [FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0]
    
    // MARK: - func
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilt[expression.eyeBrows] ?? 0.0
        }
    }
    
}

