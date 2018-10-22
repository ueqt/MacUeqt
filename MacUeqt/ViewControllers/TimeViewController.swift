//
//  TimeViewController.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/19.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa
import EventKit

struct Day {
    var isNumber = false
    var isToday = false
    var isCurrentMonth = false
    var text = "0"
    var tooltip = ""
    var lunarText = ""
}

class TimeViewController: NSViewController {

    let calendar = Calendar.autoupdatingCurrent
    var dayZero: Date? = nil
    
    var shownItemCount = 0
    var weekdays: [String] = []
    var daysInWeek = 0
    var monthOffset = 0
    
    var currentMonth: Date? = nil
    var lastFirstWeekdayLastMonth: Date? = nil
    
    @IBOutlet weak var buttonToday: NSButton!
    @IBOutlet weak var buttonLeft: NSButton!
    @IBOutlet weak var buttonRight: NSButton!
    @IBOutlet weak var inputYear: NSTextField!
    @IBOutlet weak var inputMonth: NSTextField!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekdays = ["日", "一", "二", "三", "四", "五", "六"] // calendar.veryShortWeekdaySymbols
        daysInWeek = weekdays.count
        
//        let maxWeeksInMonth = ((calendar.maximumRange(of: .day)?.upperBound)!) / daysInWeek
//        shownItemCount = daysInWeek * (maxWeeksInMonth + 2 + 1)
        shownItemCount = daysInWeek * 7 // fixed 6 lines and 1 header
        
        // force 7 items one row
        if let flowLayout = collectionView.collectionViewLayout as? NSCollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing: flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - CGFloat(daysInWeek) * horizontalSpacing) / (CGFloat(daysInWeek) + 1)
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
        
        calculateDayZero()
        updateCurrentlyShownDays()

        updateCalendar()

    }
    @IBAction func leftClicked(_ sender: Any) {
        self.decrementMonth()
    }
    @IBAction func rightClicked(_ sender: Any) {
        self.incrementMonth()
    }
    @IBAction func gotoToday(_ sender: Any) {
        self.resetMonth()
    }
    @IBAction func yearChanged(_ sender: NSTextField) {
        recalcMonth()
        sender.window?.makeFirstResponder(self.buttonToday)
    }
    @IBAction func monthChanged(_ sender: NSTextField) {
        recalcMonth()
        sender.window?.makeFirstResponder(self.buttonToday)
    }
    
    func updateCalendar() {
        inputYear.stringValue = self.getYear()
        inputMonth.stringValue = self.getMonth()
        collectionView.reloadData()
    }
}

extension TimeViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> TimeViewController {
        // 1. Get a reference to Main.storyboard
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        // 2. Create a Scene identifier that matches the one set on ui
        let identifier = NSStoryboard.SceneIdentifier("TimeViewController")
        // 3. Instantiate MainViewController and return it
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TimeViewController else {
            fatalError("Why cant i find TimeViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

extension TimeViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let id = NSUserInterfaceItemIdentifier.init(rawValue: "CalendarDayItem")
        let item = collectionView.makeItem(withIdentifier: id, for: indexPath)
        guard let calendarItem = item as? CalendarDayItem else {
            return item
        }
        let day = self.getItemAt(index: indexPath.item)
        calendarItem.setBold(bold: !day.isNumber)
        calendarItem.setText(text: day.text)
        calendarItem.setPartlyTransparent(partlyTransparent: !day.isCurrentMonth)
        calendarItem.setHasRedBackground(hasRedBackground: day.isToday)
        calendarItem.setLunar(text: day.lunarText)
        calendarItem.setTooltip(text: day.tooltip)
        
        return calendarItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCount()
    }
}

extension TimeViewController {
    // MARK: func
    private func calculateDayZero() {
        dayZero = Date(timeIntervalSince1970: 86400 * 5)
        let now = Date()
        
        let dayZeroOrdinality = calendar.ordinality(of: .month, in: .era, for: dayZero!)!
        let nowOrdinality = calendar.ordinality(of: .month, in: .era, for: now)!
        
        monthOffset = nowOrdinality - dayZeroOrdinality
    }
    
    private func calculateMonth() {
        dayZero = Date(timeIntervalSince1970: 86400 * 5)
        // day cannot 1, because geogrin date will make it yesterday
        let now = Date().from(year: Int(self.inputYear.stringValue) ?? 1900, month: Int(self.inputMonth.stringValue) ?? 1, day: 10)
        
        let dayZeroOrdinality = calendar.ordinality(of: .month, in: .era, for: dayZero!)!
        let nowOrdinality = calendar.ordinality(of: .month, in: .era, for: now)!
        
        monthOffset = nowOrdinality - dayZeroOrdinality
    }
    
    private func daysInMonth(month: Date) -> Int {
        return (calendar.range(of: .day, in: .month, for: month)?.count)!
    }
    
    private func getLastFirstWeekday(month: Date) -> Date {
        // zero-based weekday of the date "month"
        let weekday = (daysInWeek + calendar.component(.weekday, from: month) - calendar.firstWeekday) % daysInWeek
        
        // the date of the first day that same week (eg. the monday of that week)
        let d = calendar.ordinality(of: .day, in: .month, for: month)! - weekday
        
        // calculate full weeks left after the day number "d" and add that to d, to get the "last first day of the month"
        let totalDaysInMonth = daysInMonth(month: month)
        let lastFirstWeekdayNumber = (totalDaysInMonth - d) / daysInWeek * daysInWeek + d
        return calendar.date(bySetting: .day, value: lastFirstWeekdayNumber, of: month)!
    }
    
    private func updateCurrentlyShownDays() {
        currentMonth = calendar.date(byAdding: .month, value: monthOffset, to: dayZero!)
        let lastMonth = calendar.date(byAdding: .month, value: Int(-1), to: currentMonth!)!
        lastFirstWeekdayLastMonth = getLastFirstWeekday(month: lastMonth)
    }
    
    func itemCount() -> Int {
        return shownItemCount
    }
    
    func getItemAt(index: Int) -> Day {
        var day = Day()
        
        if (index < daysInWeek) {
            day.text = weekdays[(calendar.firstWeekday + index - 1) % daysInWeek]
        } else {
            let dayOffset = index - daysInWeek
            let date = calendar.date(byAdding: .day, value: dayOffset, to: lastFirstWeekdayLastMonth!)!
            
            day.isNumber = true
            day.text = String(calendar.ordinality(of: .day, in: .month, for: date)!)
            day.isCurrentMonth = calendar.isDate(date, equalTo: currentMonth!, toGranularity: .month)
            day.isToday = calendar.isDateInToday(date)
            let today = Date().removeTimestamp()
            let daysBefore = date.daysFrom(date: today)
            var daysBeforeInfo = ""
            if daysBefore > 0 {
                daysBeforeInfo = "(\(daysBefore)天前)"
            } else if(daysBefore < 0) {
                daysBeforeInfo = "(\(abs(daysBefore))天后)"
            }
            let weekOfYear = Calendar.current.component(.weekOfYear, from: date)
            let (lunarMonth, lunarDay) = date.convertGregorianToLunar()
            day.lunarText = lunarDay == "初一" ? lunarMonth : lunarDay
            let constellationHoliday = date.holidayConstellation()
            if constellationHoliday != nil {
                day.lunarText = constellationHoliday!
            }
            let solarTermHoliday = date.holidaySolarTerm()
            if solarTermHoliday != nil {
                day.lunarText = solarTermHoliday!
            }
            let feastHoliday = date.holidayFeast()
            if feastHoliday != nil {
                day.lunarText = feastHoliday!
            }
            day.tooltip = "\(date.month())月\(date.day())日\(daysBeforeInfo) 第\(weekOfYear)周\n\(date.era())(\(date.zodiac()))年 \(lunarMonth)\(lunarDay)"
        }
        
        return day
    }
    
    func getMonth() -> String {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        return monthFormatter.string(from: currentMonth!)
    }
    
    func getYear() -> String {
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return yearFormatter.string(from: currentMonth!)
    }
    
    func incrementMonth() {
        monthOffset += 1
        updateCurrentlyShownDays()
        updateCalendar()
    }
    
    func decrementMonth() {
        monthOffset -= 1
        updateCurrentlyShownDays()
        updateCalendar()
    }
    
    func resetMonth() {
        calculateDayZero()
        updateCurrentlyShownDays()
        updateCalendar()
    }
    
    func recalcMonth() {
        calculateMonth()
        updateCurrentlyShownDays()
        updateCalendar()
    }
    
//    // 请求日历事件
//    func events() {
//        let eventStore = EKEventStore()
//        eventStore.requestAccess(to: .event) { (granted, error) in
//            if !granted || error != nil {
//                return
//            }
//
//            let calendars = eventStore.calendars(for: .event)
//                .filter({ (calendar) -> Bool in
//                return calendar.type == .subscription
//            })
//
//            // 获取所有的事件（前后90天）
//            let startDate = Date().from(year: 2018, month: 1, day: 1)
//            let endDate = Date().from(year: 2018, month: 12, day: 31)
//            let predicate2 = eventStore.predicateForEvents(withStart: startDate,
//                                                           end: endDate, calendars: calendars)
//
//            print("查询范围 开始:\(startDate) 结束:\(endDate)")
//
//            if let eV = eventStore.events(matching: predicate2) as [EKEvent]? {
//                for i in eV {
//                    print("标题  \(i.title)" )
//                    print("开始时间: \(i.startDate)" )
//                    print("结束时间: \(i.endDate)" )
//                }
//            }
//        }
//    }
}
