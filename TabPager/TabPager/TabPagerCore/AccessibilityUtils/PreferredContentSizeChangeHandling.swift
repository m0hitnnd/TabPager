//
//  PreferredContentSizeChangeHandling.swift
//  TabPager
//
//  Created by Mohit Anand on 10/03/19.
//  Copyright © 2019 Bugsy. All rights reserved.
//

import UIKit

protocol PreferredContentSizeChangeHandling: PreferredContentSizeChangeObserver, PreferredContentSizeChangeResponder { }

protocol PreferredContentSizeChangeObserver {
    func observeContentSizeChange()
}

@objc protocol PreferredContentSizeChangeResponder {
    @objc func respondToContentSizeChange(notification: Notification)
}

extension PreferredContentSizeChangeObserver where Self: PreferredContentSizeChangeResponder {
    func observeContentSizeChange() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.respondToContentSizeChange(notification:)),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
}
