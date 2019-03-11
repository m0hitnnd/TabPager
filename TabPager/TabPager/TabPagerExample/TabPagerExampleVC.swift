//
//  TabPagerExampleVC.swift
//  TabPager
//
//  Created by Mohit Anand on 07/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

class TabPagerExampleVC: UIViewController {
    
    private var tabBar: TabBar! {
        didSet {
            tabBar.translatesAutoresizingMaskIntoConstraints = false
            tabBar.dataSource = self
            tabBar.register(TabBarViewCell.self, forCellWithReuseIdentifier:"TabBarViewCell")
            tabBar.showsHorizontalScrollIndicator = false
            tabBar.backgroundColor = UIColor.orange
        }
    }
    
    private var tabBarHeightConstraint: NSLayoutConstraint!
    
    private let viewControllers: [String] = ["Equity", "Balanced", "Tax Saver", "Debt", "Multi Cap", "Liquid", "Medium to Long Duration"]
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addTabBar()
    }
    
    private func addTabBar() {
        setAndLayoutTabBar()
        
        view.addSubview(tabBar)
        
        

        let sizingCellWidth = self.view.frame.size.width
        let collectionViewHeight = TabBarViewCell.height(withTitle: "Height Calculator",
                                                         forWidth: sizingCellWidth)
        tabBarHeightConstraint = tabBar.heightAnchor.constraint(equalToConstant: collectionViewHeight)
        
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.topAnchor.constraint(equalTo: view.safeTopAnchor),
            tabBarHeightConstraint
            ])
    }
    
    private func setAndLayoutTabBar() {
        let flowLayout = TabPagerFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize.init(width: 75, height: 50)
        tabBar = TabBar(frame: .zero, collectionViewLayout: flowLayout)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

#warning("automatic collection view height handling on text size change")
//extension TabPagerExampleVC: PreferredContentSizeChangeHandling {
//    func respondToContentSizeChange(notification: Notification) {
////        let sizingCellWidth = self.view.frame.size.width
////        let collectionViewHeight = TabBarViewCell.height(withTitle: "Height Calculator",
////                                                         forWidth: sizingCellWidth)
////        tabBarHeightConstraint.constant = collectionViewHeight
//        tabBar.collectionViewLayout.invalidateLayout()
//    }
//
//
//}

extension TabPagerExampleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tabBarViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarViewCell", for: indexPath) as? TabBarViewCell else {
            fatalError("It should be tab bar view cell")
        }
        let title = viewControllers[indexPath.row]
        tabBarViewCell.configure(withTitle: title)
        return tabBarViewCell
    }
    
}
