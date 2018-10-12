//
//  NSDateExtensions.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/12.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation

extension NSDate {
    func time() -> String {
        let calendar = NSCalendar.current
        let hour = calendar.component(Calendar.Component.hour, from: self as Date)
        let minute = calendar.component(Calendar.Component.minute, from: self as Date)
        let second = calendar.component(Calendar.Component.second, from: self as Date)
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}
