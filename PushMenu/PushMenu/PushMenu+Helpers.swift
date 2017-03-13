//
//  PushMenu+Helpers.swift
//
//  Created by Saoud Rizwan on 3/10/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit

// Check to see if an array contains a certain index
extension Array {
    func contains(index: Int) -> Bool {
        if index <= (self.count - 1) && index >= 0 {
            return true
        } else {
            return false
        }
    }
}

// Get the quardant of a CGPoint inside of a view
extension UIView {
    enum Quadrant {
        case first
        case second
        case third
        case fourth
    }
    
    func quadrant(of point: CGPoint) -> Quadrant {
        let height = self.frame.height
        let width = self.frame.width
        
        let quad1 = CGRect(x: width/2, y: 0, width: width/2, height: height/2)
        if quad1.contains(point) {
            return .first
        }
        
        let quad2 = CGRect(x: 0, y: 0, width: width/2, height: height/2)
        if quad2.contains(point) {
            return .second
        }
        
        let quad3 = CGRect(x: 0, y: height/2, width: width/2, height: height/2)
        if quad3.contains(point) {
            return .third
        }
        
        let quad4 = CGRect(x: width/2, y: height/2, width: width/2, height: height/2)
        if quad4.contains(point) {
            return .fourth
        }
        
        return .first // this will never be returned, just here for sugary syntax
    }
}

// Syntactic sugar - so you can do something like 2.pi instead of (2 * CGFloat.pi)
extension Int {
    var pi: CGFloat {
        get {
            return CGFloat(self) * CGFloat.pi
        }
    }
}
