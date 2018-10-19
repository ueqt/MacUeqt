//
//  OpenIterm.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/4.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

struct NewFile {
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
        let currentTime = Date().time()
        
        let process = Process()
        process.launchPath = "/usr/bin/touch"
        process.arguments = ["\(path)\(currentTime).txt"]

        process.launch()
        process.waitUntilExit()
    }
//    func run() {
//        guard let scriptUrl = Bundle.main.url(forResource: "iTerm", withExtension: "scpt"),
//            let scriptContent = try? String(contentsOf: scriptUrl) else {
//                return
//        }
//
//        let script = NSAppleScript(source: scriptContent)
//        script?.executeAndReturnError(nil)
//    }
}
