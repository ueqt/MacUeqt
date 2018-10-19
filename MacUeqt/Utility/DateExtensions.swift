//
//  NSDateExtensions.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/12.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation

extension Date {
    func time() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(Calendar.Component.hour, from: self as Date)
        let minute = calendar.component(Calendar.Component.minute, from: self as Date)
        let second = calendar.component(Calendar.Component.second, from: self as Date)
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    
    func year() -> String {
        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: self as Date)
        return String(format: "%04d", year)
    }
    
    func month() -> String {
        let calendar = Calendar.current
        let month = calendar.component(Calendar.Component.month, from: self as Date)
        return String(format: "%02d", month)
    }
    
    func day() -> String {
        let calendar = Calendar.current
        let day = calendar.component(Calendar.Component.day, from: self as Date)
        return String(format: "%02d", day)
    }
    
    func from(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date = Calendar.current.date(from: dateComponents)!
        return date
    }
    
    func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: string)!
        return date
    }
    
    func daysFrom(date:Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day!
    }
    
    func removeTimestamp() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}
