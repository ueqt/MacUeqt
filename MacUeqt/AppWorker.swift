//
//  AppWorker.swift
//  MacUeqt
//
//  Created by ueqt on 2018/9/30.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

struct AppWorker {
    func finderCurrentPath() -> String? {
        guard let scriptUrl = Bundle.main.url(forResource: "finderCurrentPath", withExtension: "scpt"),
            let scriptContent = try? String(contentsOf: scriptUrl) else {
                return nil
        }

        let script = NSAppleScript(source: scriptContent)
        return script?.executeAndReturnError(nil).stringValue
    }

    func run() {
        guard let path = finderCurrentPath() else {
            return
        }

        let process = Process()
        process.launchPath = "/usr/bin/open"
        process.arguments = ["-a", "iTerm", "\(path)"]

        process.launch()
        process.waitUntilExit()
    }
}
