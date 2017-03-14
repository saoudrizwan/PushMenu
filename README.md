<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/7799382/23850750/fcc01ffe-079d-11e7-8d25-5a683f38a1a8.png" alt="PushMenu" />
</p>

<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/7799382/23857833/d92e676c-07bb-11e7-95f7-90f91d643dbc.png" alt="Platform: iOS 10+" />
    <a href="https://developer.apple.com/swift" target="_blank"><img src="https://cloud.githubusercontent.com/assets/7799382/23857836/da3cbb72-07bb-11e7-8e7e-2019da085799.png" alt="Language: Swift 3" /></a>
    <a href="https://cocoapods.org/pods/PushMenu" target="_blank"><img src="https://cloud.githubusercontent.com/assets/7799382/23857849/dfb863bc-07bb-11e7-9e0e-17f49acd419a.png" alt="CocoaPods compatible" /></a>
    <img src="https://cloud.githubusercontent.com/assets/7799382/23857856/e384cac6-07bb-11e7-9ebe-c4c1a039c8b1.png" alt="License: MIT" />
</p>

<p align="center">
    <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#7-options-limit">7 Options Limit</a>
  • <a href="#license">License</a>
</p>

PushMenu is a **revolutionary** iOS component that can easily be added to any `UIView`. PushMenu displays options which users can select **without lifting a finger**, either by using 3D Touch or sliding their finger across the menu. A cell in the menu is highlighted based on the amount of force the user applies to his screen. After a delay, that highlighted cell gets selected and its associated action gets called. PushMenu feels **right at home** with the iOS ecosystem and is a **new, yet comfortable** approach to displaying menu options to users.  

**Note:** PushMenu works on all devices - users with devices that don't support 3D Touch can simply use the backup sliding mechanism to choose options.

## Demo
*Simulators don't have 3D Touch capabilites, it's recommended to run the example project on a device.*

The first demo is of PushMenu with 3D Touch in action. The other demos are of the backup sliding mechanism.

<a href="https://www.youtube.com/watch?v=Tv_EV6f8XDY" target="_blank"><img src="https://cloud.githubusercontent.com/assets/7799382/23856687/b89c6f52-07b7-11e7-8490-f3ca9cf79ab0.png" alt="video demo" width="290" height="518" border="0" /></a>
<img src="https://cloud.githubusercontent.com/assets/7799382/23855695/f074bf8c-07b3-11e7-8a8c-d17e2dde947e.gif" alt="demo" width="290" height="518" border="0" />
<img src="https://cloud.githubusercontent.com/assets/7799382/23855696/f086d53c-07b3-11e7-9fbe-0e25ee7a7809.gif" alt="demo" width="290" height="518" border="0" />

## Quick Start
```swift
import PushMenu

class MyViewController: UIViewController {

    let photo = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.pushMenu.isEnabled = true
        photo.pushMenu.addCell(title: "Cancel", type: .cancel, action: nil)
        photo.pushMenu.addCell(title: "Save to Library", type: .normal, action: {
            // ...
        })
    }
}
```

PushMenu is **customizable**. That means you can configure:
* `.opacity`
* `.cellHeight`
* `.font`
* `.style` (`.light` or `.dark`)
* `.selectionDelay`

## Compatibility

PushMenu requires **iOS 9+** and is compatible with **Swift 3** projects.

## Installation

* Installation for <a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>:

```ruby
platform :ios, '9.0'
    target 'ProjectName' do
    use_frameworks!

      pod 'PushMenu'

end
```
* Or drag and drop the PushMenu framework into your project.

And `import PushMenu` in the files you'd like to use it.

## Usage

*It's recommended to look through the example project—it has detailed documentation of everything PushMenu has to offer.*

**Note:** throughout this document, `photo` will act as the view being animated. You can use PushMenu on any instance of a `UIView` or `UIView` subclass, such as `UILabel`, `UITextField`, `UIButton`, etc.

**Using PushMenu is easy.**

1. [Enable](#enabling-pushmenu) PushMenu for the view.

2. [Customize](#customizing-a-pushmenu) your view's PushMenu.

3. [Add option cells](#adding-option-cells).

### Enabling PushMenu
Enabling PushMenu for a view automatically creates a new instance of a `PushMenu` and attaches a `PushMenuGestureRecognizer` to the view.
```swift
photo.pushMenu.isEnabled = true
```
Setting this value to `false` will result in the `PushMenu` instance and `PushMenuGestureRecognizer` being removed.

### Customizing a PushMenu
PushMenu wouldn't be cool if you couldn't customize it for your use case.

**Style**: `.light` or `.dark` (more themes will be available in future releases, feel free to contribute and add your own themes!)
```swift
photoView.pushMenu.style = .dark // default is .light
```
**Opacity**: the alpha value of the cells' background colors.
```swift
photoView.pushMenu.opacity = 0.75 // default is 1.0
```
**Cell Height**: the height for each option cell.
```swift
photoView.pushMenu.cellHeight = 45 // default is 55
```
**Font**: the font for the cells' title labels.
```swift
photoView.pushMenu.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium) // default is UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
```
**Selection Delay**: how long it takes (in seconds) for a highlighted cell to become selected.
```swift
photoView.pushMenu.selectionDelay = 0.7 // default is 0.45
```

### Adding Option Cells
PushMenu can only have 7 options - [why?](#7-options-limit)

All PushMenus should have a cancel option first. Cancel options don't become selected, giving users as much time as they need to decide what option they want.
Apple says the average force is ~ 1.0, the amount of force that is needed to highlight the first cell, which is why it's important that the first cell is a cancel type.
```swift
photoView.pushMenu.addCell(title: "Cancel", type: .cancel, action: nil)
```
Now you can add normal options:
```swift
photoView.pushMenu.addCell(title: "Save to Library", type: .normal, action: {
    // this closure gets called immediately after this cell is selected
})
```
... or destructive options:
```swift
photoView.pushMenu.addCell(title: "Delete Image", type: .destructive, action: {
    // ...
})
```

## 7 Options Limit
Most devices that have 3D Touch capabilites have a maximum force of 6.6666667, and Apple says that an average touch's force is ~1.0. PushMenu was built with this in mind, so each option cell of a menu takes 1 force unit. Meaning a force of 0-1 will highlight the first cell, a force of 1-2 will highlight the second cell, and so on until the 7th cell which gets highlighted from a force of 6 or above. A force unit of 1 is small, yet comfortable enough for a user to get a feel of what amount of pressure it takes to get to a certain cell.

## Documentation
Option + click on any of PushMenu's properties/methods for detailed documentation.
<img src="https://cloud.githubusercontent.com/assets/7799382/23852846/0eec6940-07a7-11e7-88a5-03b7063af8f1.png" alt="documentation">

## License

PushMenu uses the MIT license. Please file an issue if you have any questions or if you'd like to share how you're using PushMenu.

## Contribute

PushMenu is at its first stage, but is robust and powerful enough to be used in production-ready apps. Please feel free to submit pull requests, even if your addition/revision is minor. 
Here is a list of things to work on for future releases:
* more themes besides `.light` and `.dark`

## Questions?

Contact me by email <a href="mailto:hello@saoudmr.com">hello@saoudmr.com</a>, or by twitter <a href="https://twitter.com/sdrzn" target="_blank">@sdrzn</a>. Please create an <a href="https://github.com/saoudrizwan/PushMenu/issues">issue</a> if you come across a bug or would like a feature to be added.

## Credits
Touch icon by [iconsphere from the Noun Project](https://thenounproject.com/iconsphere/)
