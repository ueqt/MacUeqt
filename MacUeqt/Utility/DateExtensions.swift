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
        let year = calendar.component(.year, from: self)
        return String(format: "%04d", year)
    }
    
    func month() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        return String(format: "%02d", month)
    }
    
    func monthDays() -> Int {
        let calendar = Calendar.current
        return (calendar.range(of: .day, in: .month, for: self)?.count)!
    }
    
    func day() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        return String(format: "%02d", day)
    }
    
    func lunarYear() -> String {
        let calendar = Calendar(identifier: .chinese)
        let year = calendar.component(.year, from: self)
        return String(format: "%04d", year)
    }
    
    func lunarMonth() -> String {
        let calendar = Calendar(identifier: .chinese)
        let month = calendar.component(.month, from: self)
        return String(format: "%02d", month)
    }
    
    func lunarMonthDays() -> Int {
        let calendar = Calendar(identifier: .chinese)
        return (calendar.range(of: .day, in: .month, for: self)?.count)!
    }
    
    func lunarDay() -> String {
        let calendar = Calendar(identifier: .chinese)
        let day = calendar.component(.day, from: self)
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
    
    // https://github.com/cyanzhong/LunarCore 小历内核
    
    // https://www.cnblogs.com/silence-cnblogs/p/6368437.html
    // 计算日期年份的生肖
    func zodiac(withYear year: Int) -> String {
        let zodiacs: [String]  = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
        let zodiacIndex = (year - 1) % zodiacs.count
        return zodiacs[zodiacIndex]
    }
    
    func zodiac() -> String {
        let calendar = Calendar(identifier: .chinese)
        return zodiac(withYear: calendar.component(.year, from: self))
    }
    
    // 计算日期年份的天干地支
    func era(withYear year: Int) -> String {
        let heavenlyStems: [String] = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
        let earthlyBranches: [String] = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
        let heavenlyStemIndex: Int = (year - 1) % heavenlyStems.count
        let heavenlyStem: String = heavenlyStems[heavenlyStemIndex]
        let earthlyBrancheIndex: Int = (year - 1) % earthlyBranches.count
        let earthlyBranche: String = earthlyBranches[earthlyBrancheIndex]
        return heavenlyStem + earthlyBranche
    }
    
    func era() -> String {
        let calendar = Calendar(identifier: .chinese)
        return era(withYear: calendar.component(.year, from: self))
    }
    
    func holidayFeast() -> String? {
        // 公历节日
        let holidays = ["0101":"元旦节","0214":"情人节","0305":"雷锋日","0308":"妇女节","0312":"植树节","0315":"消费日","0401":"愚人节","0501":"劳动节","0504":"青年节","0601":"儿童节","0701":"建党节","0801":"建军节","0910":"教师节","1001":"国庆节","1224":"平安夜","1225":"圣诞节"]
        let key = self.month() + self.day()
        return holidays[key]
    }
    
    func holidayLunar() -> String? {
        // 除夕
        if self.lunarMonth() == "12" && Int(self.lunarDay()) == self.lunarMonthDays() {
            return "除夕"
        }
        // 农历节日
        let holidays = ["0101":"春节","0115":"元宵节","0202":"龙抬头","0505":"端午节","0707":"七夕节","0715":"中元节","0815":"中秋节","0909":"重阳节","1001":"寒衣节","1015":"下元节","1208":"腊八节","1223":"小年"]
        let key = self.lunarMonth() + self.lunarDay()
        return holidays[key]
    }
    
    func holidayConstellation() -> String? {
        // 十二星座
        let holidays = ["0321":"白羊座","0421":"金牛座","0522":"双子座","0622":"巨蟹座","0723":"狮子座","0824":"处女座","0924":"天秤座","1024":"天蝎座","1123":"射手座","1222":"摩羯座","0121":"水瓶座","0220":"双鱼座"]
        let key = self.month() + self.day()
        return holidays[key]
    }
    
    func holidaySolarTerm() -> String? {
        // 二十四节气
        let solarNames = ["立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至","小寒","大寒"]
        let year = self.year()
        let solars = DateHelper.solarTerms[Int(year)!]
        let key = self.month() + self.day()
        if let index = solars!.firstIndex(of: key) {
            if index < 0 {
                return nil
            }
            return solarNames[index]
        } else {
            return nil
        }
    }
    
    func holidayWorktime() -> Int {
        // 中国节日放假安排，外部设置，0无特殊安排，1工作，2放假
        let worktime = [
        "y2013":
            ["d0101":2,"d0102":2,"d0103":2,"d0105":1,"d0106":1,"d0209":2,"d0210":2,"d0211":2,"d0212":2,"d0213":2,"d0214":2,"d0215":2,"d0216":1,"d0217":1,"d0404":2,"d0405":2,"d0406":2,"d0407":1,"d0427":1,"d0428":1,"d0429":2,"d0430":2,"d0501":2,"d0608":1,"d0609":1,"d0610":2,"d0611":2,"d0612":2,"d0919":2,"d0920":2,"d0921":2,"d0922":1,"d0929":1,"d1001":2,"d1002":2,"d1003":2,"d1004":2,"d1005":2,"d1006":2,"d1007":2,"d1012":1],
        "y2014":
            ["d0101":2,"d0126":1,"d0131":2,"d0201":2,"d0202":2,"d0203":2,"d0204":2,"d0205":2,"d0206":2,"d0208":1,"d0405":2,"d0407":2,"d0501":2,"d0502":2,"d0503":2,"d0504":1,"d0602":2,"d0908":2,"d0928":1,"d1001":2,"d1002":2,"d1003":2,"d1004":2,"d1005":2,"d1006":2,"d1007":2,"d1011":1],
        "y2015":
            ["d0101":2,"d0102":2,"d0103":2,"d0104":1,"d0215":1,"d0218":2,"d0219":2,"d0220":2,"d0221":2,"d0222":2,"d0223":2,"d0224":2,"d0228":1,"d0404":2,"d0405":2,"d0406":2,"d0501":2,"d0502":2,"d0503":2,"d0620":2,"d0621":2,"d0622":2,"d0903":2,"d0904":2,"d0905":2,"d0906":1,"d0926":2,"d0927":2,"d1001":2,"d1002":2,"d1003":2,"d1004":2,"d1005":2,"d1006":2,"d1007":2,"d1010":1],
        "y2016":
            ["d0101":2,"d0102":2,"d0103":2,"d0206":1,"d0207":2,"d0208":2,"d0209":2,"d0210":2,"d0211":2,"d0212":2,"d0213":2,"d0214":1,"d0402":2,"d0403":2,"d0404":2,"d0430":2,"d0501":2,"d0502":2,"d0609":2,"d0610":2,"d0611":2,"d0612":1,"d0915":2,"d0916":2,"d0917":2,"d0918":1,"d1001":2,"d1002":2,"d1003":2,"d1004":2,"d1005":2,"d1006":2,"d1007":2,"d1008":1,"d1009":1],
        "y2017":
            ["d0101":2,"d0102":2,"d0122":1,"d0127":2,"d0128":2,"d0129":2,"d0130":2,"d0131":2,"d0201":2,"d0202":2,"d0204":1,"d0401":1,"d0402":2,"d0403":2,"d0404":2,"d0429":2,"d0430":2,"d0501":2,"d0527":1,"d0528":2,"d0529":2,"d0530":2,"d0930":1,"d1001":2,"d1002":2,"d1003":2,"d1004":2,"d1005":2,"d1006":2,"d1007":2,"d1008":2,"d1230":2,"d1231":2],
        "y2018":
            ["d0101":2,"d0211":1,"d0215":2,"d0216":2,"d0217":2,"d0218":2,"d0219":2,"d0220":2,"d0221":2,"d0224":1,"d0405":2,"d0406":2,"d0407":2,"d0408":1,"d0428":1,"d0429":2,"d0430":2,"d0501":2,"d0616":2,"d0617":2,"d0618":2,"d0922":2,"d0923":2,"d0924":2,"d0929":1,"d0930":1,"d1001":2,"d1002":2,"d1003":2,"d1004":2,"d1005":2,"d1006":2,"d1007":2,"d1229":1,"d1230":2,"d1231":2],
        "y2019":
            ["d0101":2,"d0202":1,"d0203":1,"d0204":2,"d0205":2,"d0206":2,"d0207":2,"d0208":2,"d0209":2,"d0210":2,"d0405":2,"d0406":2,"d0407":2,"d0501":2,"d0607":2,"d0608":2,"d0609":2,"d0913":2,"d0914":2,"d0915":2,"d0929":1,"d1001":2,"d1002":2,"d1003":2,"d1004":2,"d1005":2,"d1006":2,"d1007":2,"d1012":1]
        ]
        let ykey = "y\(self.year())"
        guard let yy = worktime[ykey] else {
            return 0
        }
        let key = "d\(self.month())\(self.day())"
        return yy[key] ?? 0
    }
}

