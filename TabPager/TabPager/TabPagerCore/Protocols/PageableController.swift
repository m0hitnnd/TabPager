//
//  PageableController.swift
//  TabPager
//
//  Created by Mohit Anand on 13/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

protocol PageableController: class {
    var pageIndex: Int { get set }
}

extension PageableController where Self: UIViewController {
    
}
