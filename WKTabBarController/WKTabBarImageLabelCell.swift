//
//  Created by Adrian Mateoaea on 28/09/2016.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

open class WKTabBarImageLabelCell: WKTabBarImageCell {
    
    open override func set(model: WKTabBarItem) {
        super.set(model: model)
        textLabel?.text = model.title
    }
    
    override open func commonInit() {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let textLabel = UILabel()
        textLabel.text = "Label"
        textLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        self.imageView = imageView
        self.textLabel = textLabel
    }
    
}
