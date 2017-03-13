//
//  PushMenu.swift
//
//  Created by Saoud Rizwan on 3/7/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit

public enum PushMenuStyle {
    case light
    case dark
}

class PushMenu: UIView {
    
    // default attributes
    var opacity: CGFloat = 1.0
    var font: UIFont = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
    var cellHeight: CGFloat = PushMenuCell.attributes.defaultHeight {
        didSet {
            let radius = (6 * cellHeight) + PushMenuCell.attributes.firstCircleRadius
            let diameter = radius * 2
            let largestPossibleOptionFrame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
            self.frame = largestPossibleOptionFrame
            
            for option in options {
                option.cell.setFrame()
            }
        }
    }
    
    var style: PushMenuStyle
    
    typealias option = (cell: PushMenuCell, action: (() -> Void)?)
    var options = [option]()
    
    init(style: PushMenuStyle) {
        self.style = style
        
        // largest possible option (largest force possible is 6.6667 so our options will be 0-1, 1-2, 2-3, 3-4, 4-5, 5-6
        let radius = (6 * cellHeight) + (cellHeight * 2)
        let diameter = radius * 2
        let largestPossibleOptionFrame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        
        super.init(frame: largestPossibleOptionFrame)
        
        self.backgroundColor = .clear
        self.layer.zPosition = CGFloat(FLT_MAX)
        
        // initial state
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addOption(title: String, type: PushMenuCellType, action: (() -> Void)?) {
        let newOptionCellIndex = self.options.count
        if newOptionCellIndex > 6 {
            print("PushMenu: You can't have more than 7 options!")
            return
        }
        let newOptionCell = PushMenuCell(index: newOptionCellIndex, title: title, style: self.style)
        newOptionCell.parent = self
        
        switch type {
        case .destructive:
            newOptionCell.isDestructive = true
        case .cancel:
            newOptionCell.isCancel = true
        default:
            break
        }
        
        options.append((cell: newOptionCell, action: action))
        
        self.addSubview(newOptionCell)
        newOptionCell.setFrame()
    }
    
    var quadrant: Quadrant = .first
    
    var isShowing = false
    func show(at point: CGPoint) {
        if isShowing || isHiding { return }
        isShowing = true
        self.center = point
        /* We're going to add the push menu to the key window, but behind all other views.
           Then we'll change its layer's zPosition to be as high as possible, so it's visible and ontop of all other views.
           This way, the user can still interact with the app and see the push menu at the same time.
        */
        if let keyWindow = UIApplication.shared.keyWindow {
            quadrant = keyWindow.quadrant(of: point)
            keyWindow.insertSubview(self, at: 0)
        }
        
        // prime the menu for first show
        highlightCell(index: 0)
        
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)
        self.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (_) in
            self.isShowing = false
        }
        
    }
    
    var isHiding = false
    func hide() {
        if isHiding { return }
        isHiding = true
        
        // if the highlight was by pan instead of force, first select the cell
        switch highlightType {
        case .pan:
            for option in options {
                if option.cell.isHighlighted {
                    option.cell.isSelected = true
                    option.cell.updateAttributes()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                self?.hideMenu()
            })
        case .force:
            self.hideMenu()
        }
    }
    
    func hideMenu() {
        // do the action
        self.commitAction()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }) { (_) in
            
            // reset values back to normal
            self.currentlyHighlightedCellIndex = -1
            self.isGoingToHide = false
            self.isHiding = false
            for option in self.options {
                option.cell.isSelected = false
                option.cell.isHighlighted = false
                option.cell.updateAttributes()
            }
            self.isHidden = true
            self.alpha = 1
            self.removeFromSuperview()
        }
    }
    
    enum HighlightType {
        case force
        case pan
    }
    
    var highlightType: HighlightType = .force
    
    func highlightCell(forForce force: CGFloat) {
        if self.isGoingToHide { return }
        highlightType = .force
        // cell 0 : force 0 - 1
        if force <= 1 {
            highlightCell(index: 0)
        // cell 1 : force 1 - 2
        } else if force > 1 && force <= 2 {
            highlightCell(index: 1)
        // cell 2 : force 2 - 3
        } else if force > 2 && force <= 3 {
            highlightCell(index: 2)
        // cell 3 : force 3 - 4
        } else if force > 3 && force <= 4 {
            highlightCell(index: 3)
        // cell 4 : force 4 - 5
        } else if force > 4 && force <= 5 {
            highlightCell(index: 4)
        // cell 5 : force 5 - 6
        } else if force > 5 && force <= 6 {
            highlightCell(index: 5)
        // cell 6 : force 6 or greater
        } else if force > 6 {
            highlightCell(index: 6)
        }
    }
    
    func highlightCell(forPan pannedDistance: CGFloat) {
        if self.isGoingToHide { return }
        highlightType = .pan
        let firstCircleRadius = PushMenuCell.attributes.firstCircleRadius
        if pannedDistance > firstCircleRadius && pannedDistance <= (firstCircleRadius + cellHeight) {
            highlightCell(index: 0)
        } else if pannedDistance > (firstCircleRadius + cellHeight) && pannedDistance <= (firstCircleRadius + (2 * cellHeight)) {
            highlightCell(index: 1)
        } else if pannedDistance > (firstCircleRadius + (2 * cellHeight)) && pannedDistance <= (firstCircleRadius + (3 * cellHeight)) {
            highlightCell(index: 2)
        } else if pannedDistance > (firstCircleRadius + (3 * cellHeight)) && pannedDistance <= (firstCircleRadius + (4 * cellHeight)) {
            highlightCell(index: 3)
        } else if pannedDistance > (firstCircleRadius + (4 * cellHeight)) && pannedDistance <= (firstCircleRadius + (5 * cellHeight)) {
            highlightCell(index: 4)
        } else if pannedDistance > (firstCircleRadius + (5 * cellHeight)) && pannedDistance <= (firstCircleRadius + (6 * cellHeight)) {
            highlightCell(index: 5)
        } else if pannedDistance > (firstCircleRadius + (6 * cellHeight)) {
            highlightCell(index: 6)
        }
    }
    
    var currentlyHighlightedCellIndex = -1
    var selectionDelay = 0.45 // default
    
    func highlightCell(index: Int) {
        let lastIndex = self.options.count - 1
        
        var indexToHighlight: Int!
        
        if index <= lastIndex {
            indexToHighlight = index
        } else { // force is beyond last option's force range
            indexToHighlight = lastIndex
        }
        
        // highlight desired cell and unhighlight all the rest
        for i in 0..<options.count {
            let option = options[i]
            
            if i == indexToHighlight {
                option.cell.isHighlighted = true
            } else {
                option.cell.isHighlighted = false
            }
        }
        
        // we should only do this when the highlighted cell changes
        if currentlyHighlightedCellIndex != indexToHighlight {
            currentlyHighlightedCellIndex = indexToHighlight
            
            
            for option in options {
                // if a new cell is highlighted, we need to update (in other words redraw) the PushMenu's subviews
                option.cell.updateAttributes()
            }
            
            switch highlightType {
            case .force:
                /*
                 Selecting a cell
                 After a given delay, the cell gets selected, triggering the connected action; then the push menu hides.
                 */
                
                // cancel a selection process if one is in place
                selectCellTask?.cancel()
                
                // after 0.3 seconds, select the cell
                let indexToSelect: Int = indexToHighlight
                selectCellTask = DispatchWorkItem {
                    if self.options[indexToSelect].cell.isHighlighted {
                        for i in 0..<self.options.count {
                            let option = self.options[i]
                            if i == indexToSelect {
                                option.cell.isSelected = true
                            } else {
                                option.cell.isSelected = false
                            }
                        }
                        
                        if !self.options[indexToSelect].cell.isCancel {
                            for option in self.options {
                                option.cell.updateAttributes()
                            }
                            self.isGoingToHide = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                self.hide()
                            })
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + selectionDelay, execute: selectCellTask!)
            case .pan:
                break
            }
            
           
        }
        
    }
    
    var isGoingToHide = false
    var selectCellTask: DispatchWorkItem?
    var lastSelectedCellIndex = -1
    
    // only commit an action if a cell is selected
    // and ensure that if there are somehow multiple cells selected, that only the cell farthest from the center's action is actually committed
    func commitAction() {
        for i in 0..<options.count {
            let option = options[i]
            if option.cell.isSelected && i > lastSelectedCellIndex {
                lastSelectedCellIndex = i
            }
        }
        
        if self.options.contains(index: lastSelectedCellIndex) {
            if let action = options[lastSelectedCellIndex].action {
                action()
            }
        }
        
        lastSelectedCellIndex = -1
    }

}
