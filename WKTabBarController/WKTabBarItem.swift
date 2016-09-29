//
//  Created by Adrian Mateoaea on 28/09/2016.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

public class WKTabBarItem {
    
    public var title: String?
    public var image: UIImage
    public var highlightedImage: UIImage?
    public var selectedImage: UIImage?
    public var proportion: Double = 1.0
    
    public init(image: UIImage, highlighted: UIImage? = nil, selected: UIImage? = nil) {
        self.image = image
        self.highlightedImage = highlighted
        self.selectedImage = selected
    }
    
    public init(title: String, image: UIImage, highlighted: UIImage? = nil, selected: UIImage? = nil) {
        self.title = title
        self.image = image
        self.highlightedImage = highlighted
        self.selectedImage = selected
    }
}
