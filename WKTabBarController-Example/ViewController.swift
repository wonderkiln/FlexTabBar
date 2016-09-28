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
        if IS_IPAD() {
            tabBarItems = [
                WKTabBarItem(title: "Home", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Activity", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Review", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Profile", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Add Procedure", image: #imageLiteral(resourceName: "ic_add")),
            ]
            tabBarItems[4].proportion = 1.5
        } else {
            tabBarItems = [
                WKTabBarItem(title: "Home", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Activity", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Add Procedure", image: #imageLiteral(resourceName: "ic_middle")),
                WKTabBarItem(title: "Review", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Profile", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
            ]
            tabBarItems[2].proportion = 1.5
        }
    }
    
    override func tabBarController(_ controller: WKTabBarController, customizeCell cell: WKBaseTabBarCell, at index: Int) {
        if IS_IPAD() {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            if cell.model?.title == "Add Procedure" {
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor(red:0.25, green:0.60, blue:0.75, alpha:1.00)
            } else {
                cell.textLabel?.textColor = UIColor(red:0.63, green:0.68, blue:0.77, alpha:1.00)
                cell.backgroundColor = UIColor.clear
            }
        } else {
            if cell.model?.title == "Add Procedure" {
                cell.imageView?.transform = CGAffineTransform(translationX: 0, y: -10)
            } else {
                cell.imageView?.transform = CGAffineTransform.identity
            }
        }
    }
    
    override func tabBarController(_ controller: WKTabBarController, shouldShowTitleAt index: Int) -> Bool {
        return (tabBarItems[index].title == "Add Procedure" && IS_IPAD()) || (IS_IPAD() && IS_LANDSCAPE())
    }
    
    override func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
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
        
        if tabBarItems[index].title == "Add Procedure" && !IS_IPAD() {
            let button = UIButton(type: .system)
            button.setTitle("Close", for: .normal)
            button.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
            vc.view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor, constant: 50).isActive = true
            present(vc, animated: true, completion: nil)
            return nil
        }
        
        return vc
    }

    func didTapCloseButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
