//
//  Caffeinate.swift
//  MacUeqt
//
//  Created by ueqt on 2018/11/30.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation

class CaffeinateHelper {
    // https://github.com/newmarcel/KeepingYouAwake
    // http://mos86.com/1113.html
    static var caffeinateTask: Process?
    
    static func start() {
        let arguments = NSMutableArray.init()
        // -d 将阻止显示器进入睡眠状态
        // -i 将防止系统空闲睡眠
        // -m 将阻止磁盘进入睡眠
//        arguments.add("-di")
        arguments.add(NSString(format: "-w %i", ProcessInfo.processInfo.processIdentifier))
        CaffeinateHelper.caffeinateTask = Process.launchedProcess(launchPath: "/usr/bin/caffeinate", arguments: arguments.copy() as! [String])
    }
    
    static func stop() {
        CaffeinateHelper.caffeinateTask?.terminate()
    }
}
