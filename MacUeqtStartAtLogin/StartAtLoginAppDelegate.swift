//
//  AppDelegate.swift
//  MacUeqtStartAtLogin
//
//  Created by ueqt on 2018/10/8.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

@NSApplicationMain
class StartAtLoginAppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainBundleIdentifier = "ueqt.xu.MacUeqt"
        let isRunning = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == mainBundleIdentifier
        }
        
        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            NSWorkspace.shared.launchApplication(path as String)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

