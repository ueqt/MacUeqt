//
//  AppDelegate.swift
//  MacUeqtStartAtLogin
//
//  Created by ueqt on 2018/10/8.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class StartAtLoginAppDelegate: NSObject {
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

extension StartAtLoginAppDelegate: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainBundleIdentifier = "ueqt.xu.MacUeqt"
        let isRunning = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == mainBundleIdentifier
        }
        
        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self,
                                                                selector: #selector(self.terminate),
                                                                name: .killLauncher,
                                                                object: mainBundleIdentifier)
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            NSWorkspace.shared.launchApplication(path as String)
        } else {
            self.terminate()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

