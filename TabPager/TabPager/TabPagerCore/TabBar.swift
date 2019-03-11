//
//  TabsView.swift
//  TabPager
//
//  Created by Mohit Anand on 05/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

class TabBar: UICollectionView {
    
    // MARK: Private
    private let selectedBarLineHeight = 2
    
    // MARK: Public
    public lazy var selectedBar: UIView = { [unowned self] in
        let bar  = UIView(frame: CGRect(x: 0, y: self.frame.size.height - CGFloat(self.selectedBarLineHeight), width: 0, height: CGFloat(self.selectedBarLineHeight)))
//        bar.layer.zPosition = 9999
        return bar
        }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
