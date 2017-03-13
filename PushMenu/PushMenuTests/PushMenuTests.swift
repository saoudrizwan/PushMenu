//
//  PushMenuTests.swift
//  PushMenuTests
//
//  Created by Saoud Rizwan on 3/13/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import XCTest
@testable import PushMenu

class PushMenuTests: XCTestCase {
    
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    
    func testEnablePushMenu() {
        view.pushMenu.isEnabled = true
        
        var foundPushMenuInstance = false
        for menu in PushMenuController.shared.menus {
            if menu.view === view {
                foundPushMenuInstance = true
            }
        }
        XCTAssert(foundPushMenuInstance, "PushMenu instance not created.")
        
        var foundPushMenuGestureRecognizer = false
        if let gestureRecognizers = view.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if gestureRecognizer is PushMenuGestureRecognizer {
                    foundPushMenuGestureRecognizer = true
                }
            }
        }
        XCTAssert(foundPushMenuGestureRecognizer, "PushMenuGestureRecognizer not added to view.")
    }
    
    func testExtension() {
        view.pushMenu.isEnabled = true
        
        // Set attributes for the push menu through the UIView extension.
        view.pushMenu.style = .dark
        view.pushMenu.selectionDelay = 0.3
        view.pushMenu.opacity = 0.5
        view.pushMenu.cellHeight = 40
        view.pushMenu.font = UIFont.systemFont(ofSize: 10)
        
        // Test to see if our PushMenuController properly updated the attributes for our view's associated push menu.
        XCTAssert(view.pushMenu.style == .dark, "Style not set.")
        XCTAssert(view.pushMenu.selectionDelay == 0.3, "Selection delay not set.")
        XCTAssert(view.pushMenu.opacity == 0.5, "Opacity not set.")
        XCTAssert(view.pushMenu.cellHeight == 40, "Cell height not set.")
        XCTAssert(view.pushMenu.font == UIFont.systemFont(ofSize: 10), "Font not set.")
    }
    
    func testAddCell() {
        view.pushMenu.isEnabled = true
        
        view.pushMenu.addCell(title: "TestOptionTitle", type: .normal, action: nil)
        var foundOption = false
        for menu in PushMenuController.shared.menus {
            if menu.view === view {
                for option in menu.pushMenu.options {
                    if option.cell.title == "TestOptionTitle" && !option.cell.isCancel && !option.cell.isDestructive && option.action == nil{
                        foundOption = true
                    }
                }
            }
        }
        XCTAssert(foundOption, "Failed to create new option cell.")
    }
    
    func testDisablePushMenu() {
        view.pushMenu.isEnabled = true
        
        view.pushMenu.isEnabled = false // This should remove the PushMenu instance and PushMenuGestureRecognizer associated with the view.
        
        for menu in PushMenuController.shared.menus {
            if menu.view === view {
                XCTFail("Failed to remove PushMenu instance from view.")
            }
        }
        
        if let gestureRecognizers = view.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if gestureRecognizer is PushMenuGestureRecognizer {
                    XCTFail("Failed to remove PushMenuGestureRecognizer from view.")
                }
            }
        }
    }
    
    func testMultipleEnables() {
        view.pushMenu.isEnabled = true
        view.pushMenu.isEnabled = true
        view.pushMenu.isEnabled = true
        
        // Make sure 3 PushMenu instances aren't created.
        var menuCounter = 0
        for menu in PushMenuController.shared.menus {
            if menu.view === view {
                menuCounter += 1
            }
        }
        XCTAssert(menuCounter == 1, "Too many push menus created after multiple enables.")
        
        var gestureCounter = 0
        if let gestureRecognizers = view.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if gestureRecognizer is PushMenuGestureRecognizer {
                    gestureCounter += 1
                }
            }
        }
        XCTAssert(gestureCounter == 1, "Too many PushMenuGestureRecognizers created after multiple enables.")
    }
    
    
}

