//
//  TabPagerExampleVC.swift
//  TabPager
//
//  Created by Mohit Anand on 07/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

protocol BarInfoDelegate: class {
    func title(forRow row: Int) -> String
}

protocol PagerDelegeate: class {
    func viewController(forIndex index: Int) -> PageableController?
}

typealias TabPagerDelegate = BarInfoDelegate & PagerDelegeate

class TabPagerViewController: UIViewController {
    
    private var tabBar: TabBar! {
        didSet {
            tabBar.translatesAutoresizingMaskIntoConstraints = false
            tabBar.dataSource = self
            tabBar.delegate = self
            tabBar.register(TabBarViewCell.self, forCellWithReuseIdentifier:"TabBarViewCell")
            tabBar.showsHorizontalScrollIndicator = false
            tabBar.backgroundColor = UIColor.orange
        }
    }
    
    private var containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pageViewController
    }()
    
    private var tabBarHeightConstraint: NSLayoutConstraint!
    
    private var titles: [String] = []
    
    weak var delegate: TabPagerDelegate?
    
    
    init(delegate: TabPagerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        addPageViewContainer()
    }
    
    private func setAndLayoutTabBar() {
        let flowLayout = TabPagerFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize.init(width: 75, height: 50)
        tabBar = TabBar(frame: .zero, collectionViewLayout: flowLayout)
    }
    
    private func addPageViewContainer() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        addPageViewControllerToContainer()
    }
    
    private func addPageViewControllerToContainer() {
        let controller = pageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        controller.didMove(toParent: self)
    }
    
    func configure(withTitles titles: [String], andInitialViewController viewController: PageableController) {
        self.titles = titles
        setViewController(controller: viewController)
    }
    
    private func setViewController(controller: PageableController?, direction: UIPageViewController.NavigationDirection = .forward) {
        guard let initialVC = (controller as? UIViewController) else {
            return
        }
        pageViewController.setViewControllers([initialVC], direction: direction, animated: true, completion: nil)
    }
    
}

extension TabPagerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tabBarViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarViewCell", for: indexPath) as? TabBarViewCell else {
            fatalError("It should be tab bar view cell")
        }
        let title = titles[indexPath.row]
        tabBarViewCell.configure(withTitle: title)
        return tabBarViewCell
    }
    
}

extension TabPagerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabBar.moveTo(index: indexPath.row, animated: true)
        let viewControllerAtSelectedIndex = delegate?.viewController(forIndex: indexPath.row)
        
        var direction: UIPageViewController.NavigationDirection = .forward
        if let previouslySelectedViewController = pageViewController.viewControllers?.first,
            let previouslySelectedPageableController = previouslySelectedViewController as? PageableController {
            let previouslySelectedIndex = previouslySelectedPageableController.pageIndex
            if previouslySelectedIndex < indexPath.row {
                direction = .forward
            } else {
                direction = .reverse
            }
        }

        setViewController(controller: viewControllerAtSelectedIndex, direction: direction)
    }
}

extension TabPagerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let selectedViewController = pageViewController.viewControllers?.first as? PageableController {
            let index = selectedViewController.pageIndex
            tabBar.moveTo(index: index, animated: true)
        }
    }
}

extension TabPagerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageableController = viewController as? PageableController else {
            return nil
        }
        
        let currentVCIndex = pageableController.pageIndex
        var nextIndex = 0
        
        if currentVCIndex == 0 {
            nextIndex = titles.count - 1
        } else {
            nextIndex = currentVCIndex - 1
        }
        
        return delegate?.viewController(forIndex: nextIndex) as? UIViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageableController = viewController as? PageableController else {
            return nil
        }
        
        let currentVCIndex = pageableController.pageIndex
        var nextIndex = 0
        
        if currentVCIndex == titles.count - 1 {
            nextIndex = 0
        } else {
            nextIndex = currentVCIndex + 1
        }
        return delegate?.viewController(forIndex: nextIndex) as? UIViewController
    }
    
    
}
