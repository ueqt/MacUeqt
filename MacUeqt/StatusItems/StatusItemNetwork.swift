//
//  StatusItemNetworkLabel.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/18.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemNetwork {
    var curr: Array<Substring>?
    var dSpeed: UInt64?
    var uSpeed: UInt64?
    var dSpeedLast: UInt64?
    var uSpeedLast: UInt64?
    var bandIMG: String?
    var bandColor: NSColor?
    var bandText = ""
    var finalDown: String?
    var finalUp: String?
    var pbFillRectBandwidth: NSRect?
    var dLength = 6
    var uLength = 6
    
    var bandwidthDUsageItem = NSMenuItem(title: "Download Last Hour:\t\t NA", action: nil, keyEquivalent: "")
    var bandwidthDUsageArray = Array(repeating: UInt64(0), count: 3600)
    var bandwidthDUsageArrayIndex = 0
    
    var bandwidthUUsageItem = NSMenuItem(title: "Upload Last Hour:\t\t NA", action: nil, keyEquivalent: "")
    var bandwidthUUsageArray = Array(repeating: UInt64(0), count: 3600)
    var bandwidthUUsageArrayIndex = 0
    
    func show() {
        // https://github.com/Moneypulation/iGlance
        let netstat = Process()
        netstat.launchPath = "/usr/bin/env"
        netstat.arguments = ["netstat", "-w1", "-l", "en0"]
        let pipe = Pipe()
        netstat.standardOutput = pipe
        let outputHandle = pipe.fileHandleForReading
        outputHandle.waitForDataInBackgroundAndNotify(forModes: [RunLoop.Mode.common])
        
        // when new data is avaliable
        var dataAvailable: NSObjectProtocol!
        dataAvailable = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputHandle, queue: nil) { notification -> Void in
            let data = pipe.fileHandleForReading.availableData
            if data.count > 0 {
                if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    self.curr = [""]
                    self.curr = str.replacingOccurrences(of: "  ", with: " ").replacingOccurrences(of: "  ", with: " ").replacingOccurrences(of: "  ", with: " ").replacingOccurrences(of: "  ", with: " ").split(separator: " ")
                    if (self.curr == nil || (self.curr?.count)! < 6)
                    {
                        
                    }
                    else
                    {
                        if (Int64(self.curr![2]) == nil)
                        {
                            
                        }
                        else
                        {
                            self.dSpeed = UInt64(self.curr![2])
                            self.uSpeed = UInt64(self.curr![5])
                        }
                    }
                }
                outputHandle.waitForDataInBackgroundAndNotify()
            } else {
                NotificationCenter.default.removeObserver(dataAvailable)
            }
        }
        
        // When task has finished
        var dataReady : NSObjectProtocol!
        dataReady = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: pipe.fileHandleForReading, queue: nil) { notification -> Void in
            print("Task terminated!")
            NotificationCenter.default.removeObserver(dataReady)
        }
        
        netstat.launch()
        
        if let button = AppDelegate.statusItemNetworkView.button {
            button.target = self
            button.action = #selector(showActivityMonitor)
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            self.updateUI()
        }
    }
    
    @IBAction func showActivityMonitor(_ sender: Any?) {
        let activityMonitor = Process()
        activityMonitor.launchPath = "/usr/bin/open"
        activityMonitor.arguments = ["-a", "Activity Monitor"]
        activityMonitor.launch()
    }
    
    func updateUI() {
        var needUpdate = false
        
        if (self.dSpeed != self.dSpeedLast)
        {
            needUpdate = true
        }
        
        if (self.uSpeed != self.uSpeedLast)
        {
            needUpdate = true
        }
        
        if (needUpdate)
        {
            self.updateBandText(down: self.dSpeed!, up: self.uSpeed!)
            self.dSpeedLast = self.dSpeed
            self.uSpeedLast = self.uSpeed
            
            self.bandwidthDUsageArray[self.bandwidthDUsageArrayIndex] = self.dSpeedLast!
            self.bandwidthDUsageArrayIndex += 1
            
            if (self.bandwidthDUsageArrayIndex == self.bandwidthDUsageArray.count - 1)
            {
                self.bandwidthDUsageArrayIndex = 0
            }
            
            self.bandwidthUUsageArray[self.bandwidthUUsageArrayIndex] = self.uSpeedLast!
            self.bandwidthUUsageArrayIndex += 1
            
            if (self.bandwidthUUsageArrayIndex == self.bandwidthUUsageArray.count)
            {
                self.bandwidthUUsageArrayIndex = 0
            }
            
            self.updateBandwidthMenuText(down: self.getDBandwidthUsage(), up: self.getUBandwidthUsage())
            //                self.getDBandwidthUsage()
            //                self.getUBandwidthUsage()
        }
        
        //            if (InterfaceStyle() == InterfaceStyle.Dark)
        //            {
        //                self.bandIMG = "bandwidth-white"
        //                self.bandColor = NSColor.white
        //            }
        //            else
        //            {
        self.bandIMG = "bandwidth-black"
        self.bandColor = NSColor.black
        //            }
        
        let imgFinal = NSImage(size: NSSize(width: 60, height: 18))
        imgFinal.lockFocus()
        let img1 = NSImage(named:NSImage.Name(self.bandIMG!))
        
        img1?.draw(at: NSPoint(x: 2, y: 3), from: NSZeroRect, operation: NSCompositingOperation.sourceOver, fraction: 1.0)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.00000001
        
        self.dLength = (self.finalDown?.count)!
        self.uLength = (self.finalUp?.count)!
        
        let font = NSFont(name: "Apple SD Gothic Neo Bold", size: 11.0)
        let fontSmall = NSFont(name: "Apple SD Gothic Neo Bold", size: 8.0)
        let attrString = NSMutableAttributedString(string: self.finalDown ?? "0 KB/s")
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attrString.addAttribute(.font, value: font as Any, range:NSMakeRange(0, attrString.length - 4))
        attrString.addAttribute(.font, value: fontSmall as Any, range:NSMakeRange(attrString.length - 4, 4))
        attrString.addAttribute(.foregroundColor, value: self.bandColor ?? NSColor.white, range:NSMakeRange(0, attrString.length))
        attrString.draw(at: NSPoint(x:16, y:-3))
        
        let attrString2 = NSMutableAttributedString(string: self.finalUp ?? "0 KB/s")
        attrString2.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString2.length))
        attrString2.addAttribute(.font, value: font as Any, range:NSMakeRange(0, attrString2.length - 4))
        attrString2.addAttribute(.font, value: fontSmall as Any, range:NSMakeRange(attrString2.length - 4, 4))
        attrString2.addAttribute(.foregroundColor, value: self.bandColor ?? NSColor.white, range:NSMakeRange(0, attrString2.length))
        attrString2.draw(at: NSPoint(x:16, y:7))
        imgFinal.unlockFocus()
        if let button = AppDelegate.statusItemNetworkView.button {
            imgFinal.isTemplate = true
            button.image = imgFinal
        }
    }
    
    func updateBandwidthMenuText(down: UInt64, up: UInt64)
    {
        var mFinalDown = ""
        var mFinalUp = ""
        if (down < 1024)
        {
            // B
            mFinalDown = "0 KB"
        }
        else if (down < 1048576)
        {
            // KB
            mFinalDown = String((Int(down / 1024) / 4) * 4) + " KB"
        }
        else if (down < 1073741824)
        {
            // MB
            mFinalDown = String(format: "%.1f", Double(down) / 1048576.0) + " MB"
        }
        else
        {
            // GB
            mFinalDown = String(format: "%.1f", Double(down) / 1073741824.0) + " GB"
        }
        
        
        if (up < 1024)
        {
            // B
            mFinalUp = "0 KB"
        }
        else if (up < 1048576)
        {
            // KB
            mFinalUp = String((Int(up / 1024) / 4) * 4) + " KB"
        }
        else if (up < 1073741824)
        {
            // MB
            mFinalUp = String(format: "%.1f", Double(up) / 1048576.0) + " MB"
        }
        else
        {
            // GB
            mFinalUp = String(format: "%.1f", Double(up) / 1073741824.0) + " GB"
        }
        
        
        //bandText = finalDown! + "\n" + finalUp!
        bandwidthDUsageItem.title = "Download Last Hour:\t\t " + mFinalDown
        bandwidthUUsageItem.title = "Upload Last Hour:\t\t " + mFinalUp
    }
    
    func updateBandText(down: UInt64, up: UInt64)
    {
        if (down < 1024)
        {
            // B
            finalDown = "0 KB/s"
        }
        else if (down < 1048576)
        {
            // KB
            finalDown = String((Int(down / 1024) / 4) * 4) + " KB/s"
        }
        else
        {
            // MB
            finalDown = String(format: "%.1f", Double(down) / 1048576.0) + " MB/s"
        }
        
        if (up < 1024)
        {
            // B
            finalUp = "0 KB/s"
        }
        else if (up < 1048576)
        {
            // KB
            finalUp = String((Int(up / 1024) / 4) * 4) + " KB/s"
        }
        else
        {
            // MB
            finalUp = String(format: "%.1f", Double(up) / 1048576.0) + " MB/s"
        }
        bandText = finalDown! + "\n" + finalUp!
    }
    
    func getDBandwidthUsage() -> UInt64
    {
        var total = UInt64(0)
        for num in bandwidthDUsageArray
        {
            total += num
        }
        return total
    }
    
    func getUBandwidthUsage() -> UInt64
    {
        var total = UInt64(0)
        for num in bandwidthUUsageArray
        {
            total += num
        }
        return total
    }
    
}
