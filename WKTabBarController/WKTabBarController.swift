//
//  WKTabBarController.swift
//  WKTabBarController-Example
//
//  Created by Adrian Mateoaea on 09/09/16.
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

public protocol WKTabBarControllerProtocol {
    func tabBarController(_ controller: WKTabBarController, shouldShowTitleAt index: Int) -> Bool
    func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController?
    func tabBarController(_ controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, at index: Int)
}

open class WKTabBarImageCell: UICollectionViewCell {
    
    open var model: WKTabBarItem? {
        didSet {
            imageView.image = isSelected ? (model?.selectedImage ?? model?.image) : model?.image
        }
    }
    
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
            UIView.transition(with: imageView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                if self.isHighlighted {
                                    self.imageView.image = self.model?.highlightedImage ?? self.model?.image
                                } else {
                                    self.imageView.image = self.model?.image
                                }
                },
                              completion: nil)
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            UIView.transition(with: imageView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                if self.isSelected {
                                    self.imageView.image = self.model?.selectedImage ?? self.model?.image
                                } else {
                                    self.imageView.image = self.model?.image
                                }
                },
                              completion: nil)
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

open class WKTabBarController: UIViewController, WKTabBarControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open var tabBarBackgroundImage: UIImage? {
        didSet {
            if let image = tabBarBackgroundImage {
                collectionView?.backgroundView = UIImageView(image: image)
            }
        }
    }
    
    open var collectionView: UICollectionView!
    open var indicatorView: UIView!
    
    weak var viewController: UIViewController?
    
    func changeViewController(_ vc: UIViewController) {
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParentViewController()
        
        container.addSubview(vc.view)
        vc.view.frame = container.bounds
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        
        viewController = vc
    }
    
    public var tabBarItems: [WKTabBarItem] = [] {
        didSet {
            collectionView?.reloadData()
        }
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
    
    var container: UIView!
    
    func commonInit() {
        container = UIView()
        container.backgroundColor = UIColor.clear
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 48).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.clipsToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundView = UIImageView(image: tabBarBackgroundImage)
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
        collectionView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeOrientation(_:)),
            name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
            object: nil)
    }
    
    // MARK: WKTabBarControllerProtocol
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarItems.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WKTabBarImageCell
        let item = tabBarItems[indexPath.row]
        
        if tabBarController(self, shouldShowTitleAt: indexPath.row) {
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WKTabBarImageLabelCell",
                                                              for: indexPath) as! WKTabBarImageLabelCell
            textCell.label.text = item.title
            cell = textCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WKTabBarImageCell",
                                                      for: indexPath) as! WKTabBarImageCell
        }
        
        cell.model = item
        tabBarController(self, customizeCell: cell, at: indexPath.row)
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let proportion = tabBarItems[indexPath.row].proportion
        let sum = tabBarItems.reduce(0.0) { $0.0 + $0.1.proportion }
        return CGSize(width: collectionView.bounds.width * CGFloat(proportion / sum), height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = tabBarController(self, viewControllerAtIndex: indexPath.row) {
            selectedIndex = indexPath.row
            changeViewController(vc)
        }
    }
    
    var selectedIndex: Int = 0
    
    public func setSelectedIndex2(_ index: Int) {
        let indexPath = IndexPath(index: selectedIndex)
        collectionView.selectItem(at: indexPath,
                                  animated: false,
                                  scrollPosition: .centeredHorizontally)
    }
    
    func didChangeOrientation(_ notification: Notification) {
        collectionView.reloadData()
        setSelectedIndex2(selectedIndex)
    }
    
    // MARK: WKTabBarControllerProtocol
    
    open func tabBarController(_ controller: WKTabBarController, shouldShowTitleAt index: Int) -> Bool {
        return false
    }
    
    open func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
        return nil
    }
    
    open func tabBarController(_ controller: WKTabBarController, customizeCell cell: WKTabBarImageCell, at index: Int) {
        //
    }
    
}
