//
//  ViewController.swift
//  PushMenuExample
//
//  Created by Saoud Rizwan on 3/11/17.
//  Copyright © 2017 Saoud Rizwan. All rights reserved.
//

import UIKit
import PushMenu

class ViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Intro
         --------------------
         PushMenu is a new approach to presenting a menu to a user and letting them choose an option without lifing their finger off the screen.
         
         How does PushMenu work?
         - First, the user puts his finger on the view.
         - The PushMenu pops up, now the user can choose any option in the menu by either applying varying pressure or sliding his finger across the menu.
         - If the user uses force to select an option, then that option is highlighted for ~ half a second until it gets selected. The menu then closes and the action associated with that option cell is triggered. This selection delay can be customized.
         If the user selects an option by sliding his finger across the menu, then wherever the user ends the pan gesture is the option that gets selected.
         
         Note: the cancel type option cell is an exception - no matter how long it is highlighted, it will never get selected. This allows the user to look at and think about the options before choosing one.
         
         Suggestions
         - PushMenu is tested and ready for production apps. However, it may be hard for users to grasp how to use PushMenu in the first place. It's suggested to present some sort of alert or demo that explains how to use PushMenu.
         */
        
        // Enable Push Menu on the view - setting this to true creates a new instance of PushMenu() and a PushMenuGestureRecognizer() which the PushMenuController shared instance will handle automatically.
        photoView.pushMenu.isEnabled = true
        
        // Choose a .dark or .light theme. Default is .light.
        photoView.pushMenu.style = .light
        
        // Set a desired selection delay for the menu's options. This is basically how long it takes for a cell to select while its highlighted.
        // The default value is about half a second (0.45s), so you don't have to set this either.
        photoView.pushMenu.selectionDelay = 0.46
        
        // Change the alpha values of the push menu's cells background color. Default is 1.0.
        photoView.pushMenu.opacity = 0.7
        
        // Change the option cell's heights like so. Default is 55 points.
        photoView.pushMenu.cellHeight = 45
        
        // Change the font of the cell's titles. Default is UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        photoView.pushMenu.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        
        // Now add options to the menu for the desired view. It's recommended to always create a cancel option first. Otherwise, when the user opens the menu then after half a second he will have selected the first cell without meaning to. A cancel type option doesn't trigger a selection no matter how long the cancel option is highlighted.
        photoView.pushMenu.addCell(title: "Cancel", type: .cancel, action: nil)
        
        photoView.pushMenu.addCell(title: "Save to Library", type: .normal, action: {
            print("'Save to Library' selected!")
            self.showAlert(message: "Saved to Library")
        })
        
        photoView.pushMenu.addCell(title: "Copy to Clipboard", type: .normal, action: {
            print("'Copy to Clipboard' selected!")
            self.showAlert(message: "Copied to Clipboard")
        })
        
        photoView.pushMenu.addCell(title: "Share with Friends", type: .normal, action: {
            print("'Share with Friends' selected!")
            self.showAlert(message: "Shared with Friends")
        })
        
        // This is a destructive option - nothing differs from this cell and anyother option cell except its appearance.
        photoView.pushMenu.addCell(title: "Delete Image", type: .destructive, action: {
            print("'Delete Image' selected!")
            self.showAlert(message: "Deleted Image")
        })
        
        /*
         A few last words...
         --------------------
         - PushMenu determines the angle and direction of the text in the cells by figuring out what quardant the user's tap is on the screen's coordinate system.
         This ensures that the cells' text is always visible/readable and not cut off. You may run into problems with cells with lengthy titles. In that case, I suggest editing the quadrant angles in PushMenuCell.swift.
         
         - .light and .dark are just two themes I put together to get PushMenu on its feet. I plan on integrating many more themes in future releases.
         
         - If you take a look at the implementation of showAlert(message:) below, you'll notice that there's a 0.3 second delay before showing the user an alert after they select an option from the push menu. This is by design - it takes 0.3 seconds for the push menu to animate off the screen. The action you declared when creating the option cell for the push menu is called immediately after the cell is selected.
         */
    }
    
    func showAlert(message text: String) {
        // It takes 0.3 seconds for the push menu to animate off view. So you should probably show any UI feedback with a delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
            guard self != nil else { return }
            let alert = UIView()
            alert.backgroundColor = .white
            alert.frame = CGRect(x: 0, y: 0, width: self!.photoView.frame.width / 1.5, height: 45)
            alert.center = self!.photoView.center
            alert.layer.cornerRadius = alert.frame.height / 2
            
            let message = UILabel()
            message.text = text
            message.textAlignment = .center
            message.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
            message.frame = CGRect(x: 0, y: 0, width: alert.frame.width, height: alert.frame.height)
            alert.addSubview(message)
            
            alert.alpha = 0
            alert.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            self!.view.addSubview(alert)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                alert.alpha = 1
                alert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (_) in
                UIView.animate(withDuration: 0.4, delay: 1.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                    alert.alpha = 0
                    alert.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                }, completion: { (_) in
                    alert.removeFromSuperview()
                })
            }
        })
    }
    
}

