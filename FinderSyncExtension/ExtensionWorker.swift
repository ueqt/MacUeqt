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
    
    func finderCurrentPath() -> String? {
        guard let scriptUrl = Bundle.main.url(forResource: "getFinderCurrentPath", withExtension: "scpt"),
            let scriptContent = try? String(contentsOf: scriptUrl) else {
                return nil
        }
        
        let script = NSAppleScript(source: scriptContent)
        return script?.executeAndReturnError(nil).stringValue
    }

    func run() {
//        guard let scriptUrl = Bundle.main.url(forResource: "iTerm", withExtension: "scpt") else {
//            return
//        }
//
//        guard let script = try? NSUserAppleScriptTask(url: scriptUrl) else {
//            return
//        }
//
//        script.execute(completionHandler: nil)

//        guard let path = finderCurrentPath() else {
//            return
//        }
        
        let process = Process()
        process.launchPath = "/usr/bin/open"
        process.arguments = ["-a", "iTerm", "\(self.path)"]
        
        process.launch()
        process.waitUntilExit()
    }

}
