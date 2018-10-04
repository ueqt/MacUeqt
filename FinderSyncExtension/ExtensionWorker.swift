//
//  ExtensionWorker.swift
//  FinderSyncExtension
//
//  Created by ueqt on 2018/9/30.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

struct ExtensionWorker {
    let path: String

    init(path: String) {
        self.path = path
    }

    func run() {
        guard let scriptUrl = Bundle.main.url(forResource: "iTerm", withExtension: "scpt") else {
            return
        }

        guard let script = try? NSUserAppleScriptTask(url: scriptUrl) else {
            return
        }

        script.execute(completionHandler: nil)

//        let script = NSAppleScript(source: scriptContent)
//        guard let path = script?.executeAndReturnError(nil).stringValue else {
//            return
//        }

//        let process = Process()
//        process.launchPath = "/Applications/iTerm.app/Contents/MacOS/iTerm2"
////        process.arguments = ["\(self.path)"]
////        process.launchPath = "/usr/bin/open"
////        process.arguments = ["-a", "iTerm", "\(self.path)"]
////        process.launchPath = "/usr/local/bin/code"
////        process.arguments = ["."]
//
////        process.launchPath = "echo"
////        process.arguments = ["hello"]
////
////        process.standardOutput = NSLog
//
//        process.launch()
//        process.waitUntilExit()
    }

}
