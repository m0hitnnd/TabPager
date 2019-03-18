//
//  TabPagerExampleVC.swift
//  TabPager
//
//  Created by Mohit Anand on 07/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

protocol PagerDelegate: class {
    func viewController(forIndex index: Int) -> PageableController?
}

class TabPagerViewController: UIViewController {
    
    enum ContentFlow {
        case freeFlow
        case contentBased
    }
    
    private var style: TabBarStyle = TabBarStyle()
    
    private let tabBar: TabBar = {
        let flowLayout = TabPagerFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize.init(width: 75, height: 50)
        let tabBar = TabBar(frame: .zero, collectionViewLayout: flowLayout)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.register(TabBarViewCell.self, forCellWithReuseIdentifier:"TabBarViewCell")
        tabBar.showsHorizontalScrollIndicator = false
        tabBar.backgroundColor = UIColor.orange
        return tabBar
    }()
    
    private let containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController.init(transitionStyle: .scroll,
                                                           navigationOrientation: .horizontal,
                                                           options: nil)
        return pageViewController
    }()
    
    
    private lazy var tabBarHeightConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint()
    }()
    private lazy var containerViewHeightConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint()
    }()
    
    private lazy var titles: [String] = []
    
    private var contentFlow: ContentFlow = .freeFlow
    
    weak var delegate: PagerDelegate?
    
    init(delegate: PagerDelegate, style: TabBarStyle = TabBarStyle.init(), flow: ContentFlow = .freeFlow) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.style = style
        self.contentFlow = flow

        setupUI()
    }
    
    init(style: TabBarStyle = TabBarStyle.init(), flow: ContentFlow = .freeFlow) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = nil
        self.style = style
        self.contentFlow = flow
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    private func setupUI() {
        addTabBar()
        addPageViewContainer()
        addPageViewControllerToContainer()
        
        applyStyle()
    }
    
    private func applyStyle() {
        tabBar.applyStyle(style: style)
    }
    
    private func addTabBar() {
        tabBar.dataSource = self
        tabBar.delegate = self

        view.addSubview(tabBar)
        
        let sizingCellWidth = self.view.frame.size.width
        // Providing any dummy content to calculate height of the collection view
        let collectionViewHeight = TabBarViewCell.height(withTitle: "Height Calculator",
                                                         andStyle: style.barItemStyle,
                                                         forWidth: sizingCellWidth)
        tabBarHeightConstraint = tabBar.heightAnchor.constraint(equalToConstant: collectionViewHeight)
        
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.topAnchor.constraint(equalTo: view.safeTopAnchor),
            tabBarHeightConstraint
            ])
    }
    
    private func addPageViewContainer() {
        view.addSubview(containerView)
        
        // default container view height
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerViewHeightConstraint
            ])
        
        if contentFlow == .freeFlow {
            containerViewHeightConstraint.isActive = false
        }
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
        updatePageViewContainerHeight(height: viewController.fittingHeight())
    }
    
    private func setViewController(controller: PageableController?,
                                   direction: UIPageViewController.NavigationDirection = .forward,
                                   completion: ((Bool) -> Void)? = nil) {
        
        guard let initialVC = (controller as? UIViewController) else {
            return
        }
        pageViewController.setViewControllers([initialVC], direction: direction, animated: true, completion: completion)
    }
    
}

// MARK: Size Helpers
private extension TabPagerViewController {
    
    //If the child view controller updates its preferredContentSize, in response to subviews being added/removed, then the parent view controller (the container) will receive call to its -preferredContentSizeDidChangeForChildContentContainer: method. Using this opportunity to adjust the height of the Container View.
    func notifyParentAboutTheSizeChange() {
        let width = self.view.bounds.width
        preferredContentSize = CGSize.init(width: width, height: tabBarHeightConstraint.constant + containerViewHeightConstraint.constant)
    }
    
    func updatePageViewContainerHeightAndNotifyParent(height: CGFloat) {
        guard contentFlow == .contentBased else { return }
        updatePageViewContainerHeight(height: height)
        notifyParentAboutTheSizeChange()
    }
    
    func updatePageViewContainerHeight(height: CGFloat) {
        guard contentFlow == .contentBased else { return }
        containerViewHeightConstraint.constant = height
    }
}

extension TabPagerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tabBarViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarViewCell", for: indexPath) as? TabBarViewCell else {
            assertionFailure("TabBarViewCell required at \(#file) - line num - \(#line)")
            return UICollectionViewCell()
        }
        let title = titles[indexPath.row]
        tabBarViewCell.configure(withTitle: title, andItemStyle: style.barItemStyle)
        return tabBarViewCell
    }
    
}

extension TabPagerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewControllerAtSelectedIndex = delegate?.viewController(forIndex: indexPath.row),
            let previouslySelectedViewController = pageViewController.viewControllers?.first,
            let previouslySelectedPageableController = previouslySelectedViewController as? PageableController,
            previouslySelectedPageableController.pageIndex != indexPath.row else {
                return
        }
        
        tabBar.moveTo(index: indexPath.row, animated: true)
        
        var direction: UIPageViewController.NavigationDirection = .forward
        let previouslySelectedIndex = previouslySelectedPageableController.pageIndex
        
        if previouslySelectedIndex < indexPath.row {
            direction = .forward
        } else {
            direction = .reverse
        }
        
        setViewController(controller: viewControllerAtSelectedIndex, direction: direction)
        updatePageViewContainerHeightAndNotifyParent(height: viewControllerAtSelectedIndex.fittingHeight())
    }
}

extension TabPagerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
//        guard completed else { return }
        if let selectedViewController = pageViewController.viewControllers?.first as? PageableController {
            updatePageViewContainerHeightAndNotifyParent(height: selectedViewController.fittingHeight())
            tabBar.moveTo(index: selectedViewController.pageIndex, animated: true)
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
