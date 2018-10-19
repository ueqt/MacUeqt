//
//  StatusItemTimeLabel.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/18.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemTime: StatusItemPopupBase {
    override func show() {
        self.statusItem = AppDelegate.statusItemTimeView
        super.show()
        // update time
        if let button = AppDelegate.statusItemTimeView.button {
            let date = Date()
            button.title = date.time()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                let date = Date()
                button.title = date.time()
            }
        }
        
        self.popover.contentViewController = TimeViewController.freshController()
    }
}
