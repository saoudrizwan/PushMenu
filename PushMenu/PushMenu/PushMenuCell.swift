//
//  PushMenuOption.swift
//
//  Created by Saoud Rizwan on 3/7/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit

public enum PushMenuCellType {
    case normal
    case destructive
    case cancel
}

class PushMenuCell: UIView {
    weak var parent: PushMenu? = nil
    
    let index: Int
    let title: String
    
    let style: PushMenuStyle
    
    var isHighlighted = false
    var isCancel = false
    var isDestructive = false
    var isSelected = false
    
    struct attributes {
        static let firstCircleRadius: CGFloat = 45
        static let separatorWidth: CGFloat = 1.5
        static let defaultHeight: CGFloat = 55
        
        struct style {
            
            // light theme
            struct light {
                
                struct colors {
                    static let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    static let lightGray = UIColor(red: 237.0/255.0, green: 236.0/255.0, blue: 238.0/255.0, alpha: 1.0)
                    static let gray = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
                    static let black = UIColor.black
                    static let blue = UIColor(red: 55.0/255.0, green: 126.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    static let red = UIColor(red: 241.0/255.0, green: 4.0/255.0, blue: 2.0/255.0, alpha: 1.0)
                    static let lightRed = UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                }
                
                static let separatorColor = UIColor(red: 235.0/255.0, green: 234.0/255.0, blue: 236.0/255.0, alpha: 1.0)
                
                // normal
                struct normal {
                    static let backgroundColor = colors.white
                    static let fontColor = colors.black
                    struct highlighted {
                        static let backgroundColor = colors.lightGray
                        static let fontColor = colors.black
                    }
                    struct selected {
                        static let backgroundColor = colors.blue
                        static let fontColor = colors.white
                    }
                }
                
                // destructive
                struct destructive {
                    static let backgroundColor = colors.white
                    static let fontColor = colors.red
                    struct highlighted {
                        static let backgroundColor = colors.lightGray
                        static let fontColor = colors.red
                    }
                    struct selected {
                        static let backgroundColor = colors.red
                        static let fontColor = colors.white
                    }
                    
                }
                
                // cancel
                struct cancel {
                    static let fontColor = UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                    struct highlighted {
                        static let backgroundColor = colors.lightGray
                        static let fontColor = UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0)
                    }
                }
            }
            
            // dark theme
            struct dark {
                struct colors {
                    static let white = UIColor.white
                    static let lightGray = UIColor(red: 87.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 1.0)
                    static let gray = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
                    static let black = UIColor.black
                    static let blue = UIColor(red: 55.0/255.0, green: 126.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    static let red = UIColor(red: 241.0/255.0, green: 4.0/255.0, blue: 2.0/255.0, alpha: 1.0)
                    static let lightRed = UIColor(red: 255.0/255.0, green: 121.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                }
                
                static let separatorColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1.0)
                
                // normal
                struct normal {
                    static let backgroundColor = colors.gray
                    static let fontColor = colors.white
                    struct highlighted {
                        static let backgroundColor = colors.lightGray
                        static let fontColor = colors.white
                    }
                    struct selected {
                        static let backgroundColor = colors.blue
                        static let fontColor = colors.white
                    }
                }
                
                // destructive
                struct destructive {
                    static let backgroundColor = colors.gray
                    static let fontColor = colors.lightRed
                    struct highlighted {
                        static let backgroundColor = colors.lightGray
                        static let fontColor = colors.lightRed
                    }
                    struct selected {
                        static let backgroundColor = colors.red
                        static let fontColor = colors.white
                    }
                    
                }
                
                // cancel
                struct cancel {
                    static let fontColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
                    struct highlighted {
                        static let backgroundColor = colors.lightGray
                        static let fontColor = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    }
                }
            }
            
            
        }
    }
    
    init(index: Int, title: String, style: PushMenuStyle) {
        let frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        self.index = index
        self.title = title
        self.style = style
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFrame() {
        guard let pushMenu = parent else { return }
        
        let radius = (CGFloat(index + 1) * pushMenu.cellHeight) + attributes.firstCircleRadius
        let diameter = radius * 2
        
        self.frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        self.center = pushMenu.center
        
        self.updateAttributes()
    }
    
    override func draw(_ rect: CGRect) {
        guard let pushMenu = parent else { return }
        
        let innerCircleSideLength = self.frame.height - (2 * pushMenu.cellHeight)
        let innerCircleOffset = pushMenu.cellHeight
        let innerCircleFrame = CGRect(x: innerCircleOffset, y: innerCircleOffset, width: innerCircleSideLength, height: innerCircleSideLength)
        
        // draw inner circle
        let innerCirclePath = UIBezierPath(ovalIn: innerCircleFrame)
        innerCirclePath.close()
        // if first circle, add another circle with evenOdd for first separator
        
        // draw outer circle
        let outerCircleFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let outerCirclePath = UIBezierPath(ovalIn: outerCircleFrame)
        
        // clip out the inner circle to create donut
        outerCirclePath.append(innerCirclePath)
        outerCirclePath.addClip()
        outerCirclePath.usesEvenOddFillRule = true
        outerCirclePath.close()
        
        // background color
        
        switch self.style {
        case .light:
            if (isHighlighted && !isSelected) || (isHighlighted && isCancel) { // highlighted
                if isDestructive {
                    attributes.style.light.destructive.highlighted.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                } else if isCancel {
                    attributes.style.light.cancel.highlighted.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                } else {
                    attributes.style.light.normal.highlighted.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                }
            } else if isHighlighted && isSelected && !isCancel { // selected
                if isDestructive {
                    attributes.style.light.destructive.selected.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                } else {
                    attributes.style.light.normal.selected.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                }
            } else { // not highlighted or selected
                if isDestructive {
                    attributes.style.light.destructive.backgroundColor.withAlphaComponent(pushMenu.opacity).setFill()
                } else {
                    attributes.style.light.normal.backgroundColor.withAlphaComponent(pushMenu.opacity).setFill()
                }
            }
        case .dark:
            if (isHighlighted && !isSelected) || (isHighlighted && isCancel) { // highlighted
                if isDestructive {
                    attributes.style.dark.destructive.highlighted.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                } else if isCancel {
                    attributes.style.dark.cancel.highlighted.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                } else {
                    attributes.style.dark.normal.highlighted.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                }
            } else if isHighlighted && isSelected && !isCancel { // selected
                if isDestructive {
                    attributes.style.dark.destructive.selected.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                } else {
                    attributes.style.dark.normal.selected.backgroundColor.withAlphaComponent(pushMenu.opacity * 1.5).setFill()
                }
            } else { // not highlighted or selected
                if isDestructive {
                    attributes.style.dark.destructive.backgroundColor.withAlphaComponent(pushMenu.opacity).setFill()
                } else {
                    attributes.style.dark.normal.backgroundColor.withAlphaComponent(pushMenu.opacity).setFill()
                }
            }
        }
        
        outerCirclePath.fill()
        
        // borders
        
        switch self.style {
        case .light:
            
            if isDestructive && (isHighlighted && isSelected && !isCancel) { // destructive and selected
                attributes.style.light.destructive.selected.backgroundColor.withAlphaComponent(pushMenu.opacity).setStroke()
            } else {
                attributes.style.light.separatorColor.withAlphaComponent(pushMenu.opacity).setStroke()
            }
            
        case .dark:
            if isDestructive && (isHighlighted && isSelected && !isCancel) { // destructive and selected
                attributes.style.light.destructive.selected.backgroundColor.withAlphaComponent(pushMenu.opacity).setStroke()
            } else {
                attributes.style.dark.separatorColor.withAlphaComponent(pushMenu.opacity).setStroke()
            }
        }
        
        // if first circle, add another circle with evenOdd for first separator
        if index == 0 {
            // inner circle border
            let innerCircleBorderPath = UIBezierPath(ovalIn: innerCircleFrame)
            innerCircleBorderPath.lineWidth = attributes.separatorWidth
            innerCircleBorderPath.close()
            
            innerCircleBorderPath.stroke()
        }
        
        // every option has an outer circle border
        
        let outerCircleBorderPath = UIBezierPath(ovalIn: outerCircleFrame)
        outerCircleBorderPath.lineWidth = attributes.separatorWidth
        outerCircleBorderPath.close()
        
        outerCircleBorderPath.stroke()
        
        
        // text
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.translateBy (x: self.frame.width / 2, y: self.frame.height / 2)
            context.scaleBy (x: 1, y: -1)
            let radius = (CGFloat(index) * pushMenu.cellHeight) + (pushMenu.cellHeight / 2) + attributes.firstCircleRadius
            
            var textColor: UIColor!
            
            switch self.style {
            case .light:
                if (isHighlighted && !isSelected) || (isHighlighted && isCancel) {
                    if isDestructive {
                        textColor = attributes.style.light.destructive.highlighted.fontColor
                    } else if isCancel {
                        textColor = attributes.style.light.cancel.highlighted.fontColor
                    } else {
                        textColor = attributes.style.light.normal.highlighted.fontColor
                    }
                } else if isHighlighted && isSelected && !isCancel {
                    if isDestructive {
                        textColor = attributes.style.light.destructive.selected.fontColor
                    } else {
                        textColor = attributes.style.light.normal.selected.fontColor
                    }
                } else {
                    if isDestructive {
                        textColor = attributes.style.light.destructive.fontColor
                    } else if isCancel {
                        textColor = attributes.style.light.cancel.fontColor
                    } else {
                        textColor = attributes.style.light.normal.fontColor
                    }
                }
            case .dark:
                if (isHighlighted && !isSelected) || (isHighlighted && isCancel) {
                    if isDestructive {
                        textColor = attributes.style.dark.destructive.highlighted.fontColor
                    } else if isCancel {
                        textColor = attributes.style.dark.cancel.highlighted.fontColor
                    } else {
                        textColor = attributes.style.dark.normal.highlighted.fontColor
                    }
                } else if isHighlighted && isSelected && !isCancel {
                    if isDestructive {
                        textColor = attributes.style.dark.destructive.selected.fontColor
                    } else {
                        textColor = attributes.style.dark.normal.selected.fontColor
                    }
                } else {
                    if isDestructive {
                        textColor = attributes.style.dark.destructive.fontColor
                    } else if isCancel {
                        textColor = attributes.style.dark.cancel.fontColor
                    } else {
                        textColor = attributes.style.dark.normal.fontColor
                    }
                }
            }
            
            var angle = 1.pi / 2
            var isClockwise = true // if it's at bottom this should be false
            
            /*
             Quardrant Angles
             --------------------
             If you have lengthy option titles then you may want to choose different angles to display the text.
             I suggest looking at an image of the four quadrants on a graph and then looking at a unit circle. Then look at the values that I handpicked below and choose your own angles. I found the angles I chose makes the titles very comfortable to read, but still visible on the screen without being cut off.
             */
            if let quadrant = self.parent?.quadrant {
                switch quadrant {
                case .first:
                    angle = 17.pi / 12 // between 4pi/3 and 3pi/2
                    isClockwise = false
                case .second:
                    angle = 19.pi / 12 // between 3pi/2 and 5pi/3
                    isClockwise = false
                case .third:
                    angle = 5.pi / 12 // between pi/3 and pi/2
                    isClockwise = true
                case .fourth:
                    angle = 7.pi / 12 // between pi/2 and 2pi/3
                    isClockwise = true
                }
            }
            
            drawCurvedString(text: self.title, context: context, radius: radius, angle: angle, color: textColor, font: pushMenu.font, clockwise: isClockwise)
            
        }
    }
    
    
    /*
     This function takes the current context and draws a curved string using a given angle and direction by drawing each character at a calculated angle.
     */
    func drawCurvedString(text: String, context: CGContext, radius: CGFloat, angle: CGFloat, color: UIColor, font: UIFont, clockwise: Bool) {
        
        let attributes = [NSFontAttributeName: font]
        
        let characters: [String] = text.characters.map { String($0) }
        var arcs: [CGFloat] = []
        var totalArc: CGFloat = 0
        
        for i in 0 ..< text.characters.count {
            arcs += [2 * asin(characters[i].size(attributes: attributes).width / (2 * radius))]
            totalArc += arcs[i]
        }
        
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection = clockwise ? -(1.pi/2) : (1.pi/2)
        
        var theta = angle - direction * totalArc / 2
        
        for i in 0 ..< text.characters.count {
            theta += direction * arcs[i] / 2
            let attributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
            context.saveGState()
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: radius * cos(theta), y: -(radius * sin(theta)))
            context.rotate(by: -(theta + slantCorrection))
            let offset = characters[i].size(attributes: attributes)
            context.translateBy (x: -offset.width / 2, y: -offset.height / 2)
            characters[i].draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
            context.restoreGState()
            
            theta += direction * arcs[i] / 2
        }
    }
    
    func updateAttributes() {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
}
