//
//  TestingTableViewController.swift
//  TabPager
//
//  Created by Mohit Anand on 13/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

class TestingTableViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TestingTableViewCell.self, forCellReuseIdentifier: "TestingTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        updateUI()
    }
    
}

extension TestingTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestingTableViewCell", for: indexPath) as? TestingTableViewCell else {
            return UITableViewCell.init()
        }
        cell.addViewControllerToParentViewController(parentViewController: self)
        cell.configure()
        return cell
    }

}

extension TestingTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let testingCell =  cell as? TestingTableViewCell else {
            return
        }
        testingCell.removeViewControllerFromParentViewController()
    }
}

extension TestingTableViewController {
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    
}
