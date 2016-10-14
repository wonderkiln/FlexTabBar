//
//  Created by Adrian Mateoaea on 09/09/16.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

open class WKTabBarController: UIViewController, WKTabBarControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var selectedIndex: Int = 0
    var container: UIView!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.clipsToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.register(WKTabBarImageCell.self, forCellWithReuseIdentifier: WKTabBarCellNameImage)
        collectionView.register(WKTabBarImageLabelCell.self, forCellWithReuseIdentifier: WKTabBarCellNameImageLabel)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    weak var viewController: UIViewController?
    
    public var tabBarBackgroundImage: UIImage? {
        didSet {
            if let image = tabBarBackgroundImage {
                collectionView.backgroundView = UIImageView(image: image)
            }
        }
    }
    
    public var tabBarItems: [WKTabBarItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    public var tabBarHeight: CGFloat = 48.0
    
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
        container = UIView()
        container.backgroundColor = UIColor.clear
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight).isActive = true
        
        collectionView.backgroundView = UIImageView(image: tabBarBackgroundImage)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeOrientation(_:)),
            name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
            object: nil)
        
        if let vc = tabBarController(self, viewControllerAtIndex: 0) {
            changeViewController(vc)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    public func register(cell: AnyClass, withName name: String) {
        collectionView.register(cell, forCellWithReuseIdentifier: name)
    }

    public func changeSelectedIndex(_ index: Int) {
        guard let vc = tabBarController(self, viewControllerAtIndex: index) else {
            return
        }
        
        changeViewController(vc)
        
        selectedIndex = index
        collectionView.reloadData()
    }
    
    // MARK: WKTabBarControllerProtocol
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarItems.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = tabBarController(self, cellNameAtIndex: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! WKBaseTabBarCell
        let item = tabBarItems[indexPath.row]
        
        tabBarController(self, customize: cell, with: item, at: indexPath.row)
        
        cell.set(model: item)
        cell.set(selected: indexPath.row == selectedIndex)
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let proportion = tabBarItems[indexPath.row].proportion
        let sum = tabBarItems.reduce(0.0) { $0.0 + $0.1.proportion }
        return CGSize(width: collectionView.bounds.width * CGFloat(proportion / sum), height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastIndexPath = IndexPath(row: selectedIndex, section: 0)
        if let cell = collectionView.cellForItem(at: lastIndexPath) as? WKBaseTabBarCell {
            cell.set(selected: false)
        }
        
        selectedIndex = indexPath.row
        
        if let cell = collectionView.cellForItem(at: indexPath) as? WKBaseTabBarCell {
            cell.set(selected: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let vc = tabBarController(self, viewControllerAtIndex: indexPath.row) else { return false }
        changeViewController(vc)
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? WKBaseTabBarCell {
            cell.set(selected: false)
        }
    }
    
    // MARK: - Private Methods
    func changeViewController(_ vc: UIViewController) {
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParentViewController()
        
        container.addSubview(vc.view)
        vc.view.frame = container.bounds
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        
        viewController = vc
    }
    
    func didChangeOrientation(_ notification: Notification) {
        collectionView.reloadData()
    }
    
    // MARK: WKTabBarControllerProtocol
    open func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
        return nil
    }
    
    open func tabBarController(_ controller: WKTabBarController, cellNameAtIndex index: Int) -> WKTabBarCellName {
        return WKTabBarCellNameImage
    }
    
    open func tabBarController(_ controller: WKTabBarController, customize cell: WKBaseTabBarCell, with item: WKTabBarItem, at index: Int) {
        //
    }
}
