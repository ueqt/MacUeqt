//
//  StatusItemMainIcon.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/18.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

let blockMenuItemLengthLarge:CGFloat = 10000
let largeSize = NSSize(width: 20, height: 18)
let smallSize = NSSize(width: 12, height: 10)

class StatusItemMain: StatusItemPopupBase {
    
    var mainStatusItemWindowController: MainStatusItemWindowController!
    var isExpand = false
    
    override func show() {
        self.statusItem = AppDelegate.statusItemMainView
        self.mainStatusItemWindowController = MainStatusItemWindowController(statusItemMain: self)
        super.show()

        let icon = NSImage(named: NSImage.Name("AppIcon"))
        icon?.isTemplate = true
        icon?.size = largeSize

        if let button = AppDelegate.statusItemMainView.button {
            button.image = icon
            button.action = #selector(mainMenuItemClicked)
            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
        }

        // https://github.com/Mortennn/Dozer
        // 把菜单左边的菜单都隐藏
        mainStatusItemWindowController.createWindows()

        self.popover.contentViewController = MainViewController.freshController()
    }
    
    @IBAction func mainMenuItemClicked(_ sender: Any?) {
        guard  let currentEvent = NSApp.currentEvent else {
            NSLog("read current event failed")
            return
        }
        if currentEvent.type == .rightMouseDown {
            if isExpand {
                mainStatusItemWindowController.createWindows()
            } else {
                if mainStatusItemWindowController.windowInstances.count > 0 {
                    let statusWindow = mainStatusItemWindowController.windowInstances[0] 
                    statusWindow.showAll()
                }
            }
        } else if currentEvent.type == .leftMouseDown {
            self.togglePopover(sender)
        }
    }
}

final class MainStatusItemWindowController {
    
    var statusItemMain: StatusItemMain!
    
    init(statusItemMain: StatusItemMain) {
        self.statusItemMain = statusItemMain
    }
    
    var windowInstances:[MainStatusItemWindow] = []
    
    public func createWindows() {
        guard let statusItemBtnWindow = AppDelegate.statusItemMainView.button?.window else {
            fatalError("get status item button window failed")
        }
        
        // removes all existing window instances
        removeWindows()
        let pixelsToRight = statusItemBtnWindow.screen!.frame.width-(statusItemBtnWindow.frame.origin.x-statusItemBtnWindow.screen!.frame.origin.x)
        for screen in NSScreen.screens {
            let frame = NSRect(
                x: screen.frame.width-pixelsToRight,
                y: screen.frame.height-22,
                width: 20,
                height: 22)
            let windowInstance = MainStatusItemWindow(frame: frame, screen:screen, statusItemMain: self.statusItemMain)
            windowInstances.append(windowInstance)
            windowInstance.orderFront(nil)
        }
        
        AppDelegate.statusItemMainView.length = blockMenuItemLengthLarge
    }
    
    public func removeWindows() {
        let _ = windowInstances.map { $0.orderOut(nil) }
        windowInstances = []
    }
}


final class MainStatusItemWindow: NSPanel {
    
    var statusItemMain: StatusItemMain!
    public var backgroundView:NSImageView!
    
    convenience init(frame:NSRect, screen:NSScreen, statusItemMain: StatusItemMain) {
        self.init(contentRect:frame, styleMask: [.nonactivatingPanel], backing: .buffered, defer: false, screen: screen)
        self.statusItemMain = statusItemMain
        self.isOpaque = false
        self.hasShadow = false
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.level = NSWindow.Level(rawValue: (NSWindow.Level.statusBar.rawValue))
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenNone]
        self.backgroundColor = NSColor(white: 1, alpha: 0)
        let backgroundImageView = NSImageView()
        backgroundImageView.autoresizingMask = [.height, .width]
        backgroundImageView.image = AppDelegate.statusItemMainView.button?.image
        backgroundImageView.image?.size = largeSize
        backgroundImageView.frame = self.contentView!.frame
        backgroundView = backgroundImageView
        self.contentView!.addSubview(backgroundImageView)
        self.ignoresMouseEvents = false
        statusItemMain.isExpand = false
    }
    
    override func mouseDown(with event: NSEvent) {
        self.statusItemMain.togglePopover(nil)
    }
    
    override func rightMouseDown(with event: NSEvent?) {
        AppDelegate.statusItemMainView.length = 20
        for window in self.statusItemMain.mainStatusItemWindowController.windowInstances {
            window.orderOut(nil)
        }
        self.statusItemMain.mainStatusItemWindowController.windowInstances = []
        AppDelegate.statusItemMainView.button?.image?.size = smallSize
        self.statusItemMain.isExpand = true
    }
    
    public func showAll() {
        self.rightMouseDown(with: nil)
    }
    
}

extension NSStatusItem {
    var isExpanded: Bool {
        return (self.length == blockMenuItemLengthLarge)
    }
}
