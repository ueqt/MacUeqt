//
//  AppDelegate.swift
//  MacUeqt
//
//  Created by ueqt on 2018/9/30.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override init() {
        self.statusItem.length = 120
        
        super.init()
    }
}

extension AppDelegate: NSApplicationDelegate {
    
    // https://www.raywenderlich.com/450-menus-and-popovers-in-menu-bar-apps-for-macos
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem.button?.addSubview(StatusBarViewController.freshController().view)
        
        let startAtLoginAppIdentifer = "ueqt.xu.MacUeqtStartAtLogin"
        let isRunning = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == startAtLoginAppIdentifer
        }
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

