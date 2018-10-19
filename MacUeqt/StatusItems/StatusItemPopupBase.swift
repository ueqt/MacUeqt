//
//  StatusItemPopupBase.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/18.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemPopupBase {
    let popover = NSPopover()
    var statusItem: NSStatusItem? = nil
    
    func show() {
        if let button = statusItem?.button {
            button.target = self // must have to popup
            button.action = #selector(togglePopover)
        }
    }
    
    @IBAction func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
}
