//
//  AutoSizingCollectionView.swift
//  TabPager
//
//  Created by Mohit Anand on 08/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

class AutoSizingCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != self.intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
