//
//  TabBaraStyle.swift
//  TabPager
//
//  Created by Mohit Anand on 16/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

public struct TabBarStyle {
    public let barBackgroundColor: UIColor = UIColor.white

    public let selectedBarLineHeight: CGFloat = 4
    public let selectedBarColor: UIColor = UIColor.black
    
    public let barItemStyle = TabBarItemStyle()
    
    public struct TabBarItemStyle {
        public let barItemBackgroundColor: UIColor = UIColor.white
        public let barItemTitleColor: UIColor = UIColor.gray
        public let barItemTitleFont: UIFont = UIFont.preferredFont(forTextStyle: .title2)
    }
}
