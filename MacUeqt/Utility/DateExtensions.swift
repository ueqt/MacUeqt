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
    
    // https://github.com/CodingFarmer-Zhang/Calendar-Swift/blob/master/Calendar/YYDataMaster.swift
    // 公历转农历
    func convertGregorianToLunar() -> (String, String) {
        let months = NSArray(array: ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"])
        let chineseDays = NSArray(array: ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七","十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"])
        
        let localeCalendar = NSCalendar(identifier: NSCalendar.Identifier.chinese)
        
        let localeComp = localeCalendar?.components(NSCalendar.Unit.day, from: self)
        let d_day = chineseDays.object(at: (localeComp?.day)! - 1)
        
        let monthComp = localeCalendar?.components(NSCalendar.Unit.month, from: self)
        let d_month = months.object(at: (monthComp?.month)! - 1)

        return (d_month as! String, d_day as! String)
    }
}
