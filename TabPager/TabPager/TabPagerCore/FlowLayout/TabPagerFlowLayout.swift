//
//  TabPagerFlowLayout.swift
//  TabPager
//
//  Created by Mohit Anand on 10/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

class TabPagerFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect),
            let collectionView = collectionView else {
            return nil
        }
        let totWidth: CGFloat = attributes.reduce(0, {  $0 + $1.size.width })

        let collectionViewWidth = collectionView.frame.size.width
        if totWidth < collectionViewWidth {
            let remainingWidth = collectionViewWidth - totWidth
            let remainingWidthDistribution = remainingWidth / CGFloat(attributes.count)
            var frameX: CGFloat = attributes.indices.contains(0) ? attributes[0].frame.minX : 0
            attributes.forEach { attr in
                let calculatedFrame = attr.frame
                attr.frame = CGRect.init(x: frameX,
                                         y: calculatedFrame.minY,
                                         width: calculatedFrame.size.width + remainingWidthDistribution,
                                         height: calculatedFrame.size.height)
                frameX += attr.frame.maxX
            }
            return attributes
        } else {
            return attributes
        }
        
    }
}
