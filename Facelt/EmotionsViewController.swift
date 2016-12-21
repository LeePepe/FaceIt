//
//  EmotionsViewController.swift
//  Facelt
//
//  Created by 李天培 on 2016/11/4.
//  Copyright © 2016年 lee. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    
    private let emotionsFaces = [
        "angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let faceVC = segue.destination.contentsViewController as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionsFaces[identifier] {
                    faceVC.expression = expression
                    if let sendingButton = sender as? UIButton {
                        faceVC.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
    
    
}

extension UIViewController {
    var contentsViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}
