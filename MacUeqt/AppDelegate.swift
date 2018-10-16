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
//    var tryLoginCount = 0
    var photo: PhotoHelper? = nil
    
    override init() {
        self.statusItem.length = 120
        
        super.init()
    }
}

extension AppDelegate: NSApplicationDelegate {
    
    // https://www.raywenderlich.com/450-menus-and-popovers-in-menu-bar-apps-for-macos
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem.button?.addSubview(StatusBarViewController.freshController().view)
        
        // start at login
        let startAtLoginAppIdentifer = "ueqt.xu.MacUeqtStartAtLogin"
        let isRunning = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == startAtLoginAppIdentifer
        }
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier)
        }
        
        // listener system sleep and awake event, only put in AppDelegate can work...
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(sleepListener), name: NSWorkspace.willSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(sleepListener), name: NSWorkspace.didWakeNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(sleepListener), name: NSWorkspace.screensDidWakeNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(sleepListener), name: NSWorkspace.screensDidSleepNotification, object: nil)
    }
    
    @objc func sleepListener(aNotification: NSNotification) {
        switch aNotification.name {
        case NSWorkspace.willSleepNotification:
            print("Going to sleep")
        // TODO: prevent sleep
        case NSWorkspace.didWakeNotification:
            print("Woke up")
        case NSWorkspace.screensDidSleepNotification:
            print("screen sleep")
        case NSWorkspace.screensDidWakeNotification:
            print("screen woke up")
//            self.tryLoginCount = 0
            self.photo = PhotoHelper(delegate: nil, matchDelegate: self)
            self.photo!.start()
//            let photo = PhotoHelper(delegate: nil)
//            photo.start()
//            sleep(1)
//            photo.capture(imageView: nil)
//            sleep(1)
//            photo.stop()
        default:
            print("\(aNotification.name) invoked")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate: PhotoMatchDelegate {
    func isMe(isMe: Bool) {
        if isMe {
            // auto login
            // https://stackoverflow.com/questions/26650253/how-to-lock-unlock-screen-in-mac-programatically
            // https://github.com/guoc/nearbt
            // https://stackoverflow.com/questions/12247151/log-into-osx-via-the-command-line
            print("auto login")
            let sourcePath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".macueqt", isDirectory: true).appendingPathComponent("loginSystem.sh")
            let process = Process()
            process.launchPath = "/bin/sh"
            process.arguments = [sourcePath.path]
            
            process.launch()
            process.waitUntilExit()
        } else {
//            self.tryLoginCount += 1
//            if self.tryLoginCount < 2 {
//                // retry 1 times
//                self.photo?.start()
//            } else {
                // put display to sleep
            // https://stackoverflow.com/questions/7701735/putting-the-display-to-sleep-shiftcontroleject-in-applescript
                print("put display to sleep")
                let process = Process()
                process.launchPath = "/usr/bin/pmset"
                process.arguments = ["displaysleepnow"]

                process.launch()
                process.waitUntilExit()
//           }
        }
    }
}

