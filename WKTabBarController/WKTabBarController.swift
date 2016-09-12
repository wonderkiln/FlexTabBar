//
//  WKTabBarController.swift
//  WKTabBarController-Example
//
//  Created by Adrian Mateoaea on 09/09/16.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

public protocol WKTabBarControllerProtocol {
    
    func tabBarControllerNumberOfItems(controller: WKTabBarController) -> Int
    func tabBarController(controller: WKTabBarController, titleAtIndex index: Int) -> String?
    func tabBarController(controller: WKTabBarController, imageAtIndex index: Int) -> UIImage?
    func tabBarController(controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, atIndex index: Int)
    func tabBarController(controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController?
    
}

public class WKTabBarImageCell: UICollectionViewCell {
    
    public var imageView: UIImageView!
    
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
//        imageView.widthAnchor.constraintEqualToConstant(16).active = true
//        imageView.heightAnchor.constraintEqualToConstant(16).active = true
        imageView.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
    }
    
}

public class WKTabBarImageLabelCell: WKTabBarImageCell {
    
    public var label: UILabel!
    
    override func commonInit() {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        imageView = UIImageView()
//        imageView.backgroundColor = UIColor.grayColor()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraintEqualToConstant(16).active = true
//        imageView.heightAnchor.constraintEqualToConstant(16).active = true
        imageView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
//        imageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        label = UILabel()
        label.text = "Label"
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraintEqualToAnchor(imageView.trailingAnchor, constant: 8).active = true
        label.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        label.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        label.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
        view.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
    }
    
}

public enum IndicatorViewType {
    case Line(CGFloat) // height
    case Dot(CGFloat)  // width = height
}

@IBDesignable
public class WKTabBarController: UIViewController, WKTabBarControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public var tabBarBackgroundImage: UIImage? {
        didSet {
            if let image = tabBarBackgroundImage {
                collectionView?.backgroundView = UIImageView(image: image)
            }
        }
    }
    
    var indicatorType: IndicatorViewType = .Dot(6.0)
    public var indicatorColor: UIColor = UIColor(red:68.0/255.0, green:132.0/255.0, blue:166.0/255.0, alpha:255.0/255.0)
    
    var indicatorSize: CGSize {
        switch indicatorType {
        case .Line(let height):
            let count = tabBarControllerNumberOfItems(self)
            let width = collectionView.frame.width / CGFloat(count)
            return CGSize(width: width, height: height)
        case .Dot(let size):
            return CGSize(width: size, height: size)
        }
    }
    
    public var collectionView: UICollectionView!
    public var indicatorView: UIView!
    
    var viewController: UIViewController?
    
    func changeViewController(vc: UIViewController) {
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParentViewController()
        
        view.insertSubview(vc.view, atIndex: 0)
        vc.view.frame = view.frame
        addChildViewController(vc)
        vc.didMoveToParentViewController(self)
        
        viewController = vc
    }
    
    var l: NSLayoutConstraint!
    
    var selectedIndex: Int = 0 {
        didSet {
            if let vc = tabBarController(self, viewControllerAtIndex: selectedIndex) {
                updateIndicatorViewAtIndex(selectedIndex)
                changeViewController(vc)
            }
        }
    }
    
    func updateIndicatorViewAtIndex(index: Int) {
        guard let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) else {
            return
        }
        
        let origin = CGPoint(x: CGRectGetMidX(cell.frame) - indicatorSize.width / 2.0, y: view.bounds.height - indicatorSize.height / 2.0)
        UIView.animateWithDuration(0.5) {
            self.indicatorView.frame = CGRect(origin: origin, size: self.indicatorSize)
            self.indicatorView.layoutIfNeeded()
        }
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.clipsToBounds = false
        collectionView.scrollEnabled = false
        collectionView.registerClass(WKTabBarImageCell.self,
                                     forCellWithReuseIdentifier: "WKTabBarImageCell")
        collectionView.registerClass(WKTabBarImageLabelCell.self,
                                     forCellWithReuseIdentifier: "WKTabBarImageLabelCell")
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        collectionView.heightAnchor.constraintEqualToConstant(49).active = true
        
        indicatorView = UIView()
        indicatorView.backgroundColor = indicatorColor
        indicatorView.layer.cornerRadius = indicatorSize.height / 2.0
        indicatorView.clipsToBounds = true
        
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = true
//        indicatorView.widthAnchor.constraintEqualToConstant(indicatorSize.width).active = true
//        indicatorView.heightAnchor.constraintEqualToConstant(indicatorSize.height).active = true
//        indicatorView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: indicatorSize.height / 2.0).active = true
//        l = indicatorView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor)
//        l.active = true
    }
    
    // MARK: WKTabBarControllerProtocol
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarControllerNumberOfItems(self)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: WKTabBarImageCell
        
        if let text = tabBarController(self, titleAtIndex: indexPath.row) {
            let textCell = collectionView.dequeueReusableCellWithReuseIdentifier("WKTabBarImageLabelCell", forIndexPath: indexPath) as! WKTabBarImageLabelCell
            
            textCell.imageView.image = tabBarController(self, imageAtIndex: indexPath.row)
            textCell.label.text = text
            
            cell = textCell
        } else {
            let textCell = collectionView.dequeueReusableCellWithReuseIdentifier("WKTabBarImageCell", forIndexPath: indexPath) as! WKTabBarImageCell
            
            textCell.imageView.image = tabBarController(self, imageAtIndex: indexPath.row)
            
            cell = textCell
        }
        
        tabBarController(self, customizeCell: cell, atIndex: indexPath.row)
        
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let count = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        return CGSize(width: collectionView.bounds.width / CGFloat(count), height: collectionView.bounds.height)
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        selectedIndex = indexPath.row
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
        updateIndicatorViewAtIndex(selectedIndex)
    }
    
    // MARK: WKTabBarControllerProtocol
    
    public func tabBarControllerNumberOfItems(controller: WKTabBarController) -> Int {
        return 0
    }
    
    public func tabBarController(controller: WKTabBarController, titleAtIndex index: Int) -> String? {
        return nil
    }
    
    public func tabBarController(controller: WKTabBarController, imageAtIndex index: Int) -> UIImage? {
        return nil
    }
    
    public func tabBarController(controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, atIndex index: Int) {
        //
    }
    
    public func tabBarController(controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
        return nil
    }
    
}
