//
//  LunarExtensions.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/22.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class LunarExtensions {
    // https://github.com/CodingFarmer-Zhang/Calendar-Swift/blob/master/Calendar/YYDataMaster.swift
    // 公历转农历
    func convertGregorianToLunar(year: Int, month: Int, day: Int) -> String {
        let months = NSArray(array: ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"])
        let chineseDays = NSArray(array: ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七","十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"])
        
        let dateString = NSString(format: "%d-%d-%d", year, month, day)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let date = dateFormater.date(from: dateString as String)
        
        let localeCalendar = NSCalendar(identifier: NSCalendar.Identifier.chinese)
        
        let localeComp = localeCalendar?.components(NSCalendar.Unit.day, from: date!)
        
        var d_str = chineseDays.object(at: (localeComp?.day)! - 1)
        
        if d_str as! String == "初一" {
            let montComp = localeCalendar?.components(NSCalendar.Unit.month, from: date!)
            d_str = months.object(at: (montComp?.month)! - 1)
        }
        return d_str as! String
    }
}
