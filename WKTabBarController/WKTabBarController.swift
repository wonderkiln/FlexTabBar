//
//  WKTabBarController.swift
//  WKTabBarController-Example
//
//  Created by Adrian Mateoaea on 09/09/16.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

public protocol WKTabBarControllerProtocol {
    
    func tabBarControllerNumberOfItems(_ controller: WKTabBarController) -> Int
    func tabBarController(_ controller: WKTabBarController, titleAtIndex index: Int) -> String?
    func tabBarController(_ controller: WKTabBarController, imageAtIndex index: Int) -> UIImage?
    func tabBarController(_ controller: WKTabBarController, selectedImageAtIndex index: Int) -> UIImage?
    func tabBarController(_ controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, atIndex index: Int)
    func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController?
    
}

open class WKTabBarImageCell: UICollectionViewCell {
    
    open var tabBar: WKTabBarController!
    
    open var imageView: UIImageView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 0.5
            } else {
                alpha = 1.0
            }
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.image = tabBar.tabBarController(tabBar, selectedImageAtIndex: 0)
            } else {
                imageView.image = tabBar.tabBarController(tabBar, imageAtIndex: 0)
            }
        }
    }
    
}

open class WKTabBarImageLabelCell: WKTabBarImageCell {
    
    open var label: UILabel!
    
    override func commonInit() {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        imageView = UIImageView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        label = UILabel()
        label.text = "Label"
        label.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
}

public enum IndicatorViewType {
    case line(CGFloat) // height
    case dot(CGFloat)  // width = height
}

@IBDesignable
open class WKTabBarController: UIViewController, WKTabBarControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open var tabBarBackgroundImage: UIImage? {
        didSet {
            if let image = tabBarBackgroundImage {
                collectionView?.backgroundView = UIImageView(image: image)
            }
        }
    }
    
    var indicatorType: IndicatorViewType = .dot(6.0)
    open var indicatorColor: UIColor = UIColor(red:68.0/255.0, green:132.0/255.0, blue:166.0/255.0, alpha:255.0/255.0)
    
    var indicatorSize: CGSize {
        switch indicatorType {
        case .line(let height):
            let count = tabBarControllerNumberOfItems(self)
            let width = collectionView.frame.width / CGFloat(count)
            return CGSize(width: width, height: height)
        case .dot(let size):
            return CGSize(width: size, height: size)
        }
    }
    
    open var collectionView: UICollectionView!
    open var indicatorView: UIView!
    
    var viewController: UIViewController?
    
    func changeViewController(_ vc: UIViewController) {
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParentViewController()
        
        view.insertSubview(vc.view, at: 0)
        vc.view.frame = view.frame
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        
        viewController = vc
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            if let vc = tabBarController(self, viewControllerAtIndex: selectedIndex) {
                updateIndicatorViewAtIndex(selectedIndex)
                changeViewController(vc)
            }
        }
    }
    
    func updateIndicatorViewAtIndex(_ index: Int) {
        guard let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) else {
            return
        }
        
        let origin = CGPoint(x: cell.frame.midX - indicatorSize.width / 2.0, y: view.bounds.height - indicatorSize.height / 2.0)
        UIView.animate(withDuration: 0.5, animations: {
            self.indicatorView.frame = CGRect(origin: origin, size: self.indicatorSize)
            self.indicatorView.layoutIfNeeded()
        }) 
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.clipsToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.register(WKTabBarImageCell.self,
                                     forCellWithReuseIdentifier: "WKTabBarImageCell")
        collectionView.register(WKTabBarImageLabelCell.self,
                                     forCellWithReuseIdentifier: "WKTabBarImageLabelCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
        indicatorView = UIView()
        indicatorView.backgroundColor = indicatorColor
        indicatorView.layer.cornerRadius = indicatorSize.height / 2.0
        indicatorView.clipsToBounds = true
        
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = true
        
        selectedIndex = 0
    }
    
    // MARK: WKTabBarControllerProtocol
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarControllerNumberOfItems(self)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WKTabBarImageCell
        
        if let text = tabBarController(self, titleAtIndex: (indexPath as NSIndexPath).row) {
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WKTabBarImageLabelCell", for: indexPath) as! WKTabBarImageLabelCell
            
            textCell.imageView.image = tabBarController(self, imageAtIndex: (indexPath as NSIndexPath).row)
            textCell.label.text = text
            
            cell = textCell
        } else {
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WKTabBarImageCell", for: indexPath) as! WKTabBarImageCell
            
            textCell.imageView.image = tabBarController(self, imageAtIndex: (indexPath as NSIndexPath).row)
            
            cell = textCell
        }
        
        cell.tabBar = self
        tabBarController(self, customizeCell: cell, atIndex: (indexPath as NSIndexPath).row)
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = self.collectionView(collectionView, numberOfItemsInSection: (indexPath as NSIndexPath).section)
        return CGSize(width: collectionView.bounds.width / CGFloat(count), height: collectionView.bounds.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
//        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? WKTabBarImageCell {
//            cell.imageView.image = tabBarController(self, selectedImageAtIndex: indexPath.row)
//            cell.imageView.setNeedsDisplay()
//        }
        
        selectedIndex = (indexPath as NSIndexPath).row
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
        updateIndicatorViewAtIndex(selectedIndex)
    }
    
    // MARK: WKTabBarControllerProtocol
    
    open func tabBarControllerNumberOfItems(_ controller: WKTabBarController) -> Int {
        return 0
    }
    
    open func tabBarController(_ controller: WKTabBarController, titleAtIndex index: Int) -> String? {
        return nil
    }
    
    open func tabBarController(_ controller: WKTabBarController, selectedImageAtIndex index: Int) -> UIImage? {
        return nil
    }
    
    open func tabBarController(_ controller: WKTabBarController, imageAtIndex index: Int) -> UIImage? {
        return nil
    }
    
    open func tabBarController(_ controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, atIndex index: Int) {
        //
    }
    
    open func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
        return nil
    }
    
}
