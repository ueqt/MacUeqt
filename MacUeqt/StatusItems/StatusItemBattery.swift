//
//  StatusItemBattery.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/18.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemBattery {
    var remainingTime: Battery.RemainingBatteryTime?
    var batteryCapacity: Double?
    let myBattery = Battery()
    var menuBattery: NSMenu?
    
    func show() {
        menuBattery = NSMenu()
        menuBattery?.addItem(NSMenuItem(title: "Capacity: ", action: nil, keyEquivalent: ""))
        menuBattery?.addItem(NSMenuItem(title: "Remaining time: ", action: nil, keyEquivalent: ""))
        AppDelegate.statusItemBatteryView.menu = menuBattery
        self.updateBattery()
        Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
            self.updateBattery()
        }
    }
    
    func updateBattery()
    {
        var batteryIconString: String?
        var fontColor: NSColor?
//        if(InterfaceStyle() == InterfaceStyle.Dark) {
//            batteryIconString = "battery-icon-white"
//            fontColor = NSColor.white
//        } else {
            batteryIconString = "battery-icon-black"
            fontColor = NSColor.black
//        }
        
        batteryCapacity = myBattery.getBatteryCapacity()
        
        // get the remaining time
        remainingTime = myBattery.getRemainingBatteryTime()
        
        // update the button to display the remaining time
        let imageFinal = NSImage(size: NSSize(width: 32, height: 32))
        imageFinal.lockFocus()
        
        let batteryIcon = NSImage(named: NSImage.Name(batteryIconString!))
        batteryIcon?.draw(at: NSPoint(x: 0, y: 0), from: NSZeroRect, operation: NSCompositingOperation.sourceOver, fraction: 1.0)
        
        var timeValue: String?
        let batteryTime: Battery.RemainingBatteryTime = remainingTime!
        if batteryTime.timeInSeconds > 0.0 {
            timeValue = String(batteryTime.hours) + ":" + String(format: "%02d", batteryTime.minutes)
        } else if batteryTime.timeInSeconds == -1.0 {
            timeValue = "calc."
        } else if batteryTime.timeInSeconds == -2.0 {
            timeValue = "电源"
        }
        
        let font = NSFont(name: "Apple SD Gothic Neo Bold", size: 9.0)
        let attrString = NSMutableAttributedString(string: timeValue! )
        attrString.addAttribute(.font, value: font as Any, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(.foregroundColor, value: fontColor as Any, range: NSMakeRange(0, attrString.length))
        let size = attrString.size()
        attrString.draw(at: NSPoint(x: 16-size.width/2, y: 16-size.height/2))
        
        imageFinal.unlockFocus()
        imageFinal.isTemplate = true
        if let button = AppDelegate.statusItemBatteryView.button {
            button.image = imageFinal
        }
        
        // update the menu entry with the current remaining time
        let timeEntry = menuBattery?.item(at: 1)
        timeEntry?.title = "剩余时间: " + timeValue!
        
        // update the menu entry with the current capacity
        let capacityEntry = menuBattery?.item(at: 0)
        capacityEntry?.title = "剩余容量: " + String(format: "%02d", Int(batteryCapacity!)) + "%"
    }
}
