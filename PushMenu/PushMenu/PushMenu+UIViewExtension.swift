//
//  PushMenu+UIViewExtension.swift
//
//  Created by Saoud Rizwan on 3/7/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit

public class PushMenuExtension {
    
    fileprivate weak var view: UIView!
    
    fileprivate init(view: UIView) {
        self.view = view
    }
    
    /// Returns whether this view has an instance of a PushMenu associated with it. Setting this value to true will result in a new instance of PushMenu being created and a PushMenuGestureRecognizer being added to this view.
    public var isEnabled: Bool {
        get {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    return true
                }
            }
            return false
        }
        
        set {
            
            if newValue {
                // isPushMenuEnabled = true : add custom gesture recognizer on view
                
                // First check to make sure we don't already have a menu/gesture recognizer attached to the view.
                if view.pushMenu.isEnabled { return }
                
                let gestureRecognizer = PushMenuGestureRecognizer(target: PushMenuController.shared, action: #selector(PushMenuController.shared.handlePan))
                view.addGestureRecognizer(gestureRecognizer)
                PushMenuController.shared.createMenu(for: view, style: .light)
            } else {
                // isPushMenuEnabled = false : remove our custom gesture recognizer and menu from push menu controller
                if let gestureRecognizers = view.gestureRecognizers {
                    for gestureRecognizer in gestureRecognizers {
                        if gestureRecognizer is PushMenuGestureRecognizer {
                            view.removeGestureRecognizer(gestureRecognizer)
                        }
                    }
                    
                    for i in 0..<PushMenuController.shared.menus.count {
                        let menu = PushMenuController.shared.menus[i]
                        if menu.view === view {
                            PushMenuController.shared.menus.remove(at: i)
                        }
                    }
                }
            }
        }
    }
    
    /// The theme of the PushMenu - see PushMenuStyle
    public var style: PushMenuStyle {
        get {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    return menu.pushMenu.style
                }
            }
            
            return .light
        }
        
        set {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    menu.pushMenu.style = newValue
                }
            }
        }
    }
    
    /// Delay in seconds that it takes a cell to go from the highlighted state to the selected state. Note: only applies if the user is using force to choose an option.
    public var selectionDelay: TimeInterval {
        get {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    return menu.pushMenu.selectionDelay
                }
            }
            return 0.45 // default
        }
        
        set {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    menu.pushMenu.selectionDelay = newValue
                }
            }
        }
    }
    
    /// The alpha value of the option cells' background colors.
    public var opacity: CGFloat {
        get {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    return menu.pushMenu.opacity
                }
            }
            return 1.0 // default
        }
        
        set {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    menu.pushMenu.opacity = newValue
                }
            }
        }
    }
    
    /// The font of the cells' titles.
    public var font: UIFont {
        get {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    return menu.pushMenu.font
                }
            }
            return UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium) // default
        }
        
        set {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    menu.pushMenu.font = newValue
                }
            }
        }
    }
    
    /// The height for each of the option cells.
    public var cellHeight: CGFloat {
        get {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    return menu.pushMenu.cellHeight
                }
            }
            return 55 // default
        }
        
        set {
            for menu in PushMenuController.shared.menus {
                if menu.view === view {
                    menu.pushMenu.cellHeight = newValue
                }
            }
        }
    }
    
    /// Add a new option cell to the view's associated PushMenu.
    ///
    /// - Parameters:
    ///   - title: the text that will go in the cell
    ///   - type: cancel, normal, or destructive
    ///   - action: a function that gets called when this cell is selected
    public func addCell(title: String, type: PushMenuCellType, action: (() -> Void)?) {
        for menu in PushMenuController.shared.menus {
            if menu.view === view {
                menu.pushMenu.addOption(title: title, type: type, action: action)
            }
        }
    }
}

@available(iOS 9.0, *)
public extension UIView {
    
    public var is3DTouchEnabled: Bool {
        get {
            if self.traitCollection.forceTouchCapability == .available {
                return true
            } else {
                return false
            }
        }
    }
    
    fileprivate struct PushMenuAssociatedKey {
        static var pushMenu = "push_menu_key"
    }
    
    public var pushMenu: PushMenuExtension {
        get {
            if let danceInstance = objc_getAssociatedObject(self, &PushMenuAssociatedKey.pushMenu) as? PushMenuExtension {
                return danceInstance
            } else {
                let newDanceInstance = PushMenuExtension(view: self)
                objc_setAssociatedObject(self, &PushMenuAssociatedKey.pushMenu, newDanceInstance, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                return newDanceInstance
            }
        }
    }

}
