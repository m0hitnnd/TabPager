//
//  ExampleViewController.swift
//  TabPager
//
//  Created by Mohit Anand on 12/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController, PageableController {
    var pageIndex: Int = 0
    
    
    public var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("child - deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("child - viewDidLoad")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("child - view will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("child - view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("child - view did disappear")
    }
    
    private func setupUI() {
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            ])
    }
    
    func configure(withText text: String) {
        label.text = text
    }

}
