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
    private let selectedBarLineHeight: CGFloat = 4
    
    
    // MARK: Public
    open lazy var selectedBar: UIView = { [unowned self] in
        let bar  = UIView(frame: CGRect(x: 0, y: self.frame.size.height - self.selectedBarLineHeight, width: 0, height: CGFloat(self.selectedBarLineHeight)))
        bar.backgroundColor = UIColor.white
        return bar
        }()
    
    var selectedIndex = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addSelectedBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSelectedBar()
    }
    
    private func addSelectedBar() {
        addSubview(selectedBar)
    }
    
    func moveTo(index: Int, animated: Bool) {
        selectedIndex = index
        updateSelectedBarPosition(animated)
    }
    
    private func updateSelectedBarPosition(_ animated: Bool) {
        var selectedBarFrame = selectedBar.frame
        
        let selectedCellIndexPath = IndexPath(item: selectedIndex, section: 0)
        let attributes = layoutAttributesForItem(at: selectedCellIndexPath)
        let selectedCellFrame = attributes!.frame
        
        scrollToItem(at: selectedCellIndexPath, at: .centeredHorizontally, animated: true)
        
        selectedBarFrame.size.width = selectedCellFrame.size.width
        selectedBarFrame.origin.x = selectedCellFrame.origin.x
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.selectedBar.frame = selectedBarFrame
            })
        } else {
            selectedBar.frame = selectedBarFrame
        }
        
    }
    
    private func updateSelectedBarYPosition() {
        var selectedBarFrame = selectedBar.frame

        selectedBarFrame.origin.y = frame.size.height - selectedBarLineHeight
        
        selectedBarFrame.size.height = selectedBarLineHeight
        selectedBar.frame = selectedBarFrame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelectedBarYPosition()
    }
    
}
