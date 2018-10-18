//
//  StatusItemTimeLabel.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/18.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemTime {
    func show() {
        // update time
        if let button = AppDelegate.statusItemTimeView.button {
            let date = NSDate()
            button.title = date.time()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {_ in
                let date = NSDate()
                button.title = date.time()
            }
        }
    }
}
