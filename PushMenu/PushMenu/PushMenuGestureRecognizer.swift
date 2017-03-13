//
//  PushMenuGestureRecognizer.swift
//
//  Created by Saoud Rizwan on 3/8/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

/*
 Custom gesture recognizer in order to retrieve the force of the user's touch.
 NOTE: You can easily use this gesture recognizer for you own views if you want the touch force values as well.
 */
class PushMenuGestureRecognizer: UIGestureRecognizer {
    
    var force: CGFloat? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
    }
    
    // touchesMoved handles when force changes on touch
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        state = .changed
        if let touch = touches.first {
            guard let traits = self.view?.traitCollection else { return }
            if traits.forceTouchCapability == .available {
                self.force = touch.force
            } else {
                self.force = nil
            }
        }
        
        /*
         TODO: If changed is more than ~ 10px then use slide mechanism instead of force mechanism.
               Or maybe that's a bad idea because what if the user slides and applies varying pressure?
               We'll see... let me know what you think.
         */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
    }
}
