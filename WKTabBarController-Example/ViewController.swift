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
    return UIDevice.current.orientation.isLandscape
}
public func IS_IPAD() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}
public func IS_IPHONE() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

class ViewController: WKTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarBackgroundImage = #imageLiteral(resourceName: "tab_bar_bg")
        tabBarItems = [
            WKTabBarItem(title: "Home", image: #imageLiteral(resourceName: "ic_home"), selected: #imageLiteral(resourceName: "ic_home_sel")),
            WKTabBarItem(title: "Activity", image: #imageLiteral(resourceName: "ic_activity"),    selected: #imageLiteral(resourceName: "ic_activity_sel")),
            WKTabBarItem(title: "Add Procedure", image: #imageLiteral(resourceName: "tab_bar_circle"), highlighted: #imageLiteral(resourceName: "tab_bar_circle_hover")),
            WKTabBarItem(title: "Review", image: #imageLiteral(resourceName: "ic_review"), selected: #imageLiteral(resourceName: "ic_review_sel")),
            WKTabBarItem(title: "Profile", image: #imageLiteral(resourceName: "ic_profile"), selected: #imageLiteral(resourceName: "ic_profile_sel"))
        ]
    }
    
    override func tabBarController(_ controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, at index: Int) {
        if IS_IPAD() && IS_LANDSCAPE() {
            if index == 4 {
                (cell as? WKTabBarImageLabelCell)?.label.textColor = UIColor.white
                cell.backgroundColor = UIColor(red:68.0/255.0, green:132.0/255.0, blue:166.0/255.0, alpha:255.0/255.0)
            } else {
                (cell as? WKTabBarImageLabelCell)?.label.textColor = UIColor(white: 0.2, alpha: 1.0)
                cell.backgroundColor = UIColor.clear
            }
        } else {
            if index == 2 {
                cell.imageView.transform = CGAffineTransform(translationX: 0, y: -10)
            } else {
                cell.imageView.transform = CGAffineTransform.identity
            }
        }
    }
    
    override func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
        if index == 2 { return nil }
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = UIColor(white: 0.8, alpha: 1.0)
        label.text = "\(index + 1)"
        
        vc.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        return vc
    }

}
