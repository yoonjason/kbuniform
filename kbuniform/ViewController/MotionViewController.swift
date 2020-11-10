//
//  MotionViewController.swift
//  kbuniform
//
//  Created by twave on 2020/11/09.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import CoreGraphics

class MotionViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var image003: UIImageView!
    @IBOutlet weak var image002: UIImageView!
    @IBOutlet weak var image001: UIImageView!
    let animation = CABasicAnimation(keyPath: "transform.scale")
    let animation1 = CABasicAnimation(keyPath: "position.x")
    let handAnimation = CABasicAnimation(keyPath: "position.y")
    


    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        showAnimation()
        image003.setNeedsDisplay()
        image003.setNeedsLayout()
        
        print(#function)
        handAnimation.delegate = self

    }
    func showAnimation () {
//        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.autoreverses = true
        animation.fromValue = 1
        animation.toValue = 1.3
        animation.duration = 0.5
        animation.delegate = self
        
        
        animation1.fromValue = image001.layer.position
        animation1.toValue = self.view.frame.width + image001.frame.width
        animation1.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation1.delegate = self
        animation1.beginTime = 1.3
        animation1.duration = 1.5
        
        
//        let animation2 = CABasicAnimation(keyPath: "")
        
        
        
        let group = CAAnimationGroup()
        group.duration = 2
        group.repeatCount = 1
        group.animations = [animation, animation1]
        group.isRemovedOnCompletion = false
        group.fillMode = .backwards
        image001.layer.add(group, forKey: nil)
        
    }
    
    
    @available(iOS 2.0, *)
    func animationDidStart(_ anim: CAAnimation) {
        print(#function)
    }
    
    @available(iOS 2.0, *)
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print(#function)
    }
    
//    func animationDidStart(_ anim : CAAnimation) {
//        print(#function, anim)
//    }
//
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        print(#function, anim)
//    }

}
