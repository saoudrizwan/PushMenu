//
//  PushMenuController.swift
//
//  Created by Saoud Rizwan on 3/8/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit

/*
 This class keeps track of all active push menus during run time. 
 It also handles the user's touch events through PushMenuGestureRecognizer.
 */
class PushMenuController: NSObject {
    
    // singleton
    static let shared = PushMenuController()
    
    var menus = [(view: UIView, pushMenu: PushMenu)]()
    
    func createMenu(for view: UIView, style: PushMenuStyle) {
        let pushMenu = PushMenu(style: style)
        menus.append((view: view, pushMenu: pushMenu))
        
    }
    
    var panStartingLocation: CGPoint = .zero
    
    func handlePan(sender: PushMenuGestureRecognizer) {
        guard let view = sender.view else { return }
        let panLocation = sender.location(in: nil) // location in window
        
        var pushMenu: PushMenu!
        for menu in menus {
            if menu.view === view {
                pushMenu = menu.pushMenu
            }
        }
        
        switch sender.state {
        case .began:
            pushMenu.show(at: panLocation)
            panStartingLocation = panLocation
        case .changed:
            let x = Float(panStartingLocation.x - panLocation.x)
            let y = Float(panStartingLocation.y - panLocation.y)
            let pannedDistance = CGFloat(hypotf(x, y))
            
            // if user isn't sliding his finger, and if 3d touch is enabled and the force value is available
            if pannedDistance <= PushMenuCell.attributes.firstCircleRadius, let force = sender.force {
                pushMenu.highlightCell(forForce: force)
            } else {
                // use sliding mechanism since force is unavailable
                pushMenu.highlightCell(forPan: pannedDistance)
            }
        default: // ended, cancelled, etc.
            pushMenu.hide()
            
        }
    }
}
