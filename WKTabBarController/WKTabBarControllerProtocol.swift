//
//  Created by Adrian Mateoaea on 28/09/2016.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

public typealias WKTabBarCellName = String

public let WKTabBarCellNameImage = "WKTabBarImageCell"
public let WKTabBarCellNameImageLabel = "WKTabBarImageLabelCell"

public protocol WKTabBarControllerProtocol {
    func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController?
    func tabBarController(_ controller: WKTabBarController, cellNameAtIndex index: Int) -> WKTabBarCellName
    func tabBarController(_ controller: WKTabBarController, customize cell: WKBaseTabBarCell, with item: WKTabBarItem, at index: Int)
}
