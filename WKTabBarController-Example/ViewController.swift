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

final class WKCustomTabBarImageLabelCell: WKTabBarImageLabelCell {
    
    var isAddButton: Bool = false
    
    open override func set(model: WKTabBarItem) {
        super.set(model: model)
        
        if isAddButton {
            textLabel?.textColor = UIColor.white
            backgroundColor = UIColor(red:0.25, green:0.60, blue:0.75, alpha:1.00)
        } else {
            textLabel?.textColor = UIColor(red:0.63, green:0.68, blue:0.77, alpha:1.00)
            backgroundColor = UIColor.clear
        }
    }
    
    override func set(selected: Bool) {
        super.set(selected: selected)
        
        if selected {
            if !isAddButton {
                textLabel?.textColor = UIColor(red:0.25, green:0.60, blue:0.75, alpha:1.00)
            }
            textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            if !isAddButton {
                textLabel?.textColor = UIColor(red:0.63, green:0.68, blue:0.77, alpha:1.00)
            }
            textLabel?.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
}

let WKTabBarCellNameCustomImageLabel = "WKTabBarCellNameCustomImageLabel"

class ViewController: WKTabBarController {

    var addButtonIndex: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register(cell: WKCustomTabBarImageLabelCell.self,
                 withName: WKTabBarCellNameCustomImageLabel)
        
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
            addButtonIndex = 4
        } else {
            tabBarItems = [
                WKTabBarItem(title: "Home", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Activity", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Add Procedure", image: #imageLiteral(resourceName: "ic_middle")),
                WKTabBarItem(title: "Review", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
                WKTabBarItem(title: "Profile", image: #imageLiteral(resourceName: "ic_item"), selected: #imageLiteral(resourceName: "ic_item_sel")),
            ]
            tabBarItems[2].proportion = 1.5
            addButtonIndex = 2
        }
    }
    
    override func tabBarController(_ controller: WKTabBarController, customize cell: WKBaseTabBarCell, with item: WKTabBarItem, at index: Int) {
        if IS_IPAD() {
            if let cell = cell as? WKCustomTabBarImageLabelCell {
                cell.isAddButton = index == addButtonIndex
            }
        } else {
            if index == addButtonIndex {
                cell.imageView?.transform = CGAffineTransform(translationX: 0, y: -10)
            } else {
                cell.imageView?.transform = CGAffineTransform.identity
            }
        }
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
        
        if index == addButtonIndex && !IS_IPAD() {
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
    
    override func tabBarController(_ controller: WKTabBarController, cellNameAtIndex index: Int) -> WKTabBarCellName {
        if (index == addButtonIndex && IS_IPAD()) || (IS_IPAD() && IS_LANDSCAPE()) {
            return WKTabBarCellNameCustomImageLabel
        } else {
            return WKTabBarCellNameImage
        }
    }

    func didTapCloseButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
