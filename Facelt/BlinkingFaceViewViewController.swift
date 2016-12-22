//
//  BlinkingFaceViewViewController.swift
//  Facelt
//
//  Created by 李天培 on 2016/12/21.
//  Copyright © 2016年 lee. All rights reserved.
//

import UIKit

class BlinkingFaceViewViewController: FaceViewController {

    var blinking: Bool = false {
        didSet {
            startBlink()
        }
    }
    
    private struct BlinkRate {
        static let ClosedDuration = 0.4
        static let OpenDuration = 2.5
    }
    
    func startBlink() {
        if blinking {
            faceView.eyesOpen = false
            Timer.scheduledTimer(timeInterval: BlinkRate.ClosedDuration,
                                 target: self, selector: #selector(BlinkingFaceViewViewController.endBlink),
                                 userInfo: nil,
                                 repeats: false)
        }
    }
    
    func endBlink() {
        faceView.eyesOpen = true
        Timer.scheduledTimer(timeInterval: BlinkRate.OpenDuration,
                             target: self, selector: #selector(BlinkingFaceViewViewController.startBlink),
                             userInfo: nil,
                             repeats: false)
    }
    
    // MARK: Controller Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        blinking = false
    }
}
