//
//  ViewController.swift
//  WKTabBarController-Example
//
//  Created by Adrian Mateoaea on 09/09/16.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit
import WKTabBarController

public func IS_LANDSCAPE() -> Bool {
    return UIDevice.currentDevice().orientation.isLandscape
}
public func IS_IPAD() -> Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad
}
public func IS_IPHONE() -> Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == .Phone
}

class ViewController: WKTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarBackgroundImage = UIImage(named: "tab_bar_bg")
    }
    
    override func tabBarControllerNumberOfItems(controller: WKTabBarController) -> Int {
        return 5
    }
    
    override func tabBarController(controller: WKTabBarController, imageAtIndex index: Int) -> UIImage? {
        if IS_IPAD() && IS_LANDSCAPE() {
            if index == 0 { return UIImage(named: "ic_home") }
            else if index == 1 { return UIImage(named: "ic_activity") }
            else if index == 2 { return UIImage(named: "ic_review") }
            else if index == 3 { return UIImage(named: "ic_profile") }
            else { return UIImage(named: "ic_home") }
        } else {
            if index == 0 { return UIImage(named: "ic_home") }
            else if index == 1 { return UIImage(named: "ic_activity") }
            else if index == 2 { return UIImage(named: "tab_bar_circle") }
            else if index == 3 { return UIImage(named: "ic_review") }
            else { return UIImage(named: "ic_profile") }
        }
    }
    
    override func tabBarController(controller: WKTabBarController, titleAtIndex index: Int) -> String? {
        if IS_IPAD() && IS_LANDSCAPE() {
            if index == 0 { return "Home" }
            else if index == 1 { return "Activity" }
            else if index == 2 { return "Review" }
            else if index == 3 { return "Profile" }
            else { return "Add Procedure" }
        }
        return nil
    }
    
    override func tabBarController(controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, atIndex index: Int) {
        if IS_IPAD() && IS_LANDSCAPE() {
            if index == 4 {
                (cell as? WKTabBarImageLabelCell)?.label.textColor = UIColor.whiteColor()
                cell.backgroundColor = UIColor(red:68.0/255.0, green:132.0/255.0, blue:166.0/255.0, alpha:255.0/255.0)
            } else {
                (cell as? WKTabBarImageLabelCell)?.label.textColor = UIColor(white: 0.2, alpha: 1.0)
                cell.backgroundColor = UIColor.clearColor()
            }
        } else {
            if index == 2 {
                cell.imageView.transform = CGAffineTransformMakeTranslation(0, -15)
            } else {
                cell.imageView.transform = CGAffineTransformIdentity
            }
        }
    }
    
    override func tabBarController(controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(48)
        label.textColor = UIColor(white: 0.8, alpha: 1.0)
        label.text = "\(index + 1)"
        
        vc.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraintEqualToAnchor(vc.view.centerXAnchor).active = true
        label.centerYAnchor.constraintEqualToAnchor(vc.view.centerYAnchor).active = true
        
        return vc
    }

}
