//
//  Created by Adrian Mateoaea on 28/09/2016.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

open class WKTabBarImageCell: WKBaseTabBarCell {
    
    var widthAnchorConstraint: NSLayoutConstraint!
    var heightAnchorConstraint: NSLayoutConstraint!
    
    open override var imageSize: CGFloat {
        didSet {
            widthAnchorConstraint?.constant = imageSize
            heightAnchorConstraint?.constant = imageSize
        }
    }
    
    var model: WKTabBarItem?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open override func set(model: WKTabBarItem) {
        super.set(model: model)
        self.model = model
        imageView?.image = model.image
    }
    
    open override func set(selected: Bool) {
        guard let imageView = imageView else { return }
        
        UIView.transition(with: imageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            if selected {
                                imageView.image = self.model?.selectedImage ?? self.model?.image
                            } else {
                                imageView.image = self.model?.image
                            }
            },
                          completion: nil)
    }
    
    open override func set(highlighted: Bool) {
        guard let imageView = imageView else { return }
        
        UIView.transition(with: imageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            if highlighted {
                                imageView.image = self.model?.highlightedImage ?? self.model?.image
                            } else {
                                imageView.image = self.model?.image
                            }
            },
                          completion: nil)
    }
    
    open override func commonInit() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        widthAnchorConstraint = imageView.widthAnchor.constraint(equalToConstant: imageSize)
        heightAnchorConstraint = imageView.heightAnchor.constraint(equalToConstant: imageSize)
        
        widthAnchorConstraint.isActive = true
        heightAnchorConstraint.isActive = true
        
        self.imageView = imageView
    }
    
    open override var isHighlighted: Bool {
        didSet {
            set(highlighted: isHighlighted)
        }
    }
}
