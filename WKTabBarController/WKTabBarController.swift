//
//  Created by Adrian Mateoaea on 09/09/16.
//  Copyright © 2016 Wonderkiln. All rights reserved.
//

import UIKit

open class WKTabBarController: UIViewController, WKTabBarControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var selectedIndex: Int = 0
    var container: UIView!
    var collectionView: UICollectionView!
    weak var viewController: UIViewController?
    
    public var tabBarBackgroundImage: UIImage? {
        didSet {
            if let image = tabBarBackgroundImage {
                collectionView?.backgroundView = UIImageView(image: image)
            }
        }
    }
    
    public var tabBarItems: [WKTabBarItem] = [] {
        didSet {
            collectionView?.reloadData()
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
        collectionView.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeOrientation(_:)),
            name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let vc = tabBarController(self, viewControllerAtIndex: 0) {
            changeViewController(vc)
        }
        
        collectionView.performBatchUpdates({
            let indexPath = IndexPath(index: 0)
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        })
    }
    
    // MARK: WKTabBarControllerProtocol
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarItems.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WKBaseTabBarCell
        let item = tabBarItems[indexPath.row]
        
        if tabBarController(self, shouldShowTitleAt: indexPath.row) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WKTabBarImageLabelCell",
                                                      for: indexPath) as! WKTabBarImageLabelCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WKTabBarImageCell",
                                                      for: indexPath) as! WKTabBarImageCell
        }
        
        cell.model = item
        tabBarController(self, customizeCell: cell, at: indexPath.row)
        cell.set(selected: indexPath.row == selectedIndex)
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let proportion = tabBarItems[indexPath.row].proportion
        let sum = tabBarItems.reduce(0.0) { $0.0 + $0.1.proportion }
        return CGSize(width: collectionView.bounds.width * CGFloat(proportion / sum), height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = tabBarController(self, viewControllerAtIndex: indexPath.row) else { return }
        
        let lastIndexPath = IndexPath(row: selectedIndex, section: 0)
        if let cell = collectionView.cellForItem(at: lastIndexPath) as? WKBaseTabBarCell {
            cell.set(selected: false)
        }
        
        selectedIndex = indexPath.row
        changeViewController(vc)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? WKBaseTabBarCell {
            cell.set(selected: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return tabBarController(self, viewControllerAtIndex: indexPath.row) != nil
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
    
    public func setSelectedTabIndex(_ index: Int) {
        if let vc = tabBarController(self, viewControllerAtIndex: index) {
            let indexPath = IndexPath(index: index)
            collectionView.selectItem(at: indexPath,
                                      animated: false,
                                      scrollPosition: .centeredHorizontally)
            
            selectedIndex = indexPath.row
            changeViewController(vc)
        }
    }
    
    func didChangeOrientation(_ notification: Notification) {
        collectionView.reloadData()
    }
    
    // MARK: WKTabBarControllerProtocol
    open func tabBarController(_ controller: WKTabBarController, shouldShowTitleAt index: Int) -> Bool {
        return false
    }
    
    open func tabBarController(_ controller: WKTabBarController, viewControllerAtIndex index: Int) -> UIViewController? {
        return nil
    }
    
    open func tabBarController(_ controller: WKTabBarController, customizeCell cell: WKBaseTabBarCell, at index: Int) {
        //
    }
}
