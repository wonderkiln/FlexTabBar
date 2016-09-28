//
//  Created by Adrian Mateoaea on 28/09/2016.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

public protocol WKTabBarControllerProtocol {
    func tabBarController(_ controller: WKTabBarController, shouldShowTitleAt index: Int) -> Bool
    func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController?
    func tabBarController(_ controller: WKTabBarController, customizeCell cell: WKBaseTabBarCell, at index: Int)
}
