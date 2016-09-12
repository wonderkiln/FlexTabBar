//
//  ViewController.swift
//  WKTabBarController-Example
//
//  Created by Adrian Mateoaea on 09/09/16.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit
import WKTabBarController

class ViewController: WKTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarBackgroundImage = UIImage(named: "tab_bar_bg")
    }
    
    override func tabBarControllerNumberOfItems(controller: WKTabBarController) -> Int {
        return 5
    }
    
    override func tabBarController(controller: WKTabBarController, imageAtIndex index: Int) -> UIImage? {
        if index == 2 && UIDevice.currentDevice().userInterfaceIdiom == .Phone { return UIImage(named: "tab_bar_circle") }
        
        if index == 0 { return UIImage(named: "ic_activity") }
        else if index == 1 { return UIImage(named: "ic_home") }
        else if index == 2 { return UIImage(named: "ic_home") }
        else if index == 3 { return UIImage(named: "ic_profile") }
        else { return UIImage(named: "ic_review") }
    }
    
    override func tabBarController(controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, atIndex index: Int) {
        if index == 2 {
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                cell.imageView.transform = CGAffineTransformMakeTranslation(0, -15)
                cell.backgroundColor = UIColor.clearColor()
            } else {
                cell.backgroundColor = UIColor.redColor()
            }
        } else {
            cell.imageView.transform = CGAffineTransformIdentity
            cell.backgroundColor = UIColor.clearColor()
        }
        
        if let cell = cell as? WKTabBarImageLabelCell {
            cell.label.font = UIFont.systemFontOfSize(14)
            cell.label.textColor = UIColor(white: 0.2, alpha: 1.0)
            if index == 2 && UIDevice.currentDevice().userInterfaceIdiom != .Phone {
                cell.label.textColor = UIColor.whiteColor()
            }
        }
    }
    
    override func tabBarController(controller: WKTabBarController, titleAtIndex index: Int) -> String? {
        if index == 2 && UIDevice.currentDevice().userInterfaceIdiom == .Phone { return nil }
        if UIDevice.currentDevice().orientation.isPortrait { return nil }
        
        if index == 0 { return "Home" }
        else if index == 1 { return "Activity" }
        else if index == 2 { return "Add Procedure" }
        else if index == 3 { return "Property" }
        else { return "Settings" }
    }
    
    override func tabBarController(controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
        if index == 2 { return nil }
        
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
