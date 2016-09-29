//
//  Created by Adrian Mateoaea on 28/09/2016.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

open class WKBaseTabBarCell: UICollectionViewCell {
    
    open var imageSize: CGFloat = 22.0
    
    public var imageView: UIImageView?
    public var textLabel: UILabel?
    
    open func set(model: WKTabBarItem) {
        //
    }
    
    open func commonInit() {
        //
    }
    
    open func set(highlighted: Bool) {
        //
    }
    
    open func set(selected: Bool) {
        //
    }
}
