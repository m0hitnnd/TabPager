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
    
    func fittingHeight() -> CGFloat
}

extension PageableController where Self: UIViewController {
    
    func fittingHeight() -> CGFloat {
        self.view.layoutIfNeeded()
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = self.view.bounds.width
        let height = self.view.systemLayoutSizeFitting(fittingSize,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .defaultLow).height
        return height
    }
    
}
