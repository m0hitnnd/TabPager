//
//  TabBarViewCell.swift
//  TabPager
//
//  Created by Mohit Anand on 06/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

public class TabBarViewCell: UICollectionViewCell {
    
    public var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private static let sizingCell = TabBarViewCell.init(frame: .zero)

    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func configureAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = [.button]
    }
    
    private func setupUI() {
        self.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    func configure(withTitle title: String) {
        label.text = title
        accessibilityLabel = title
    }
    
}

//MARK: Helpers
extension TabBarViewCell {
    public static func height(withTitle title: String, forWidth width: CGFloat) -> CGFloat {
        sizingCell.prepareForReuse()
        sizingCell.configure(withTitle: title)
        sizingCell.layoutIfNeeded()
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        let size = sizingCell.contentView.systemLayoutSizeFitting(fittingSize,
                                                                  withHorizontalFittingPriority: .required,
                                                                  verticalFittingPriority: .defaultLow)
        return size.height
    }
}
