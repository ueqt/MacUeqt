//
//  AppDelegate.swift
//  MacUeqt
//
//  Created by ueqt on 2018/9/30.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // https://www.raywenderlich.com/450-menus-and-popovers-in-menu-bar-apps-for-macos
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = NSImage(named: NSImage.Name("AppIcon"))
        icon?.isTemplate = true
        icon?.size = NSSize(width: 20, height: 18)
        if let button = statusItem.button {
            button.title = "Ueqt"
            button.image = icon
            button.action = #selector(togglePopover(_:))
        }
        ////        self.statusItem.length = 70
        popover.contentViewController = MainViewController.freshController()
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = self.statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

