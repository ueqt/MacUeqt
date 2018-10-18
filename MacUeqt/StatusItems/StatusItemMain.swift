//
//  StatusItemMainIcon.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/18.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemMain: StatusItemPopupBase {
    func show() {
        self.statusItem = AppDelegate.statusItemMainView

        let icon = NSImage(named: NSImage.Name("AppIcon"))
        icon?.isTemplate = true
        icon?.size = NSSize(width: 20, height: 18)

        if let button = AppDelegate.statusItemMainView.button {
            button.target = self // must have, otherwise action won't called
            button.image = icon
            button.action = #selector(togglePopover)
        }

        self.popover.contentViewController = MainViewController.freshController()
    }
}
