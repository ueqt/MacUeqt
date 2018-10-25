//
//  StatusItemMainIcon.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/18.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class StatusItemMain: StatusItemPopupBase {
    
    let showLength: CGFloat = 20
    let hideLength: CGFloat = 10000
    var buttonImage: NSImage!
    
    override func show() {
        self.statusItem = AppDelegate.statusItemMainView
        super.show()

        guard let button = AppDelegate.statusItemMainView.button else {
            fatalError("main status item button failed")
        }
        
        self.buttonImage = NSImage(named: NSImage.Name("AppIcon"))
        self.buttonImage.size = NSSize(width: 20, height: 18)
        self.buttonImage.isTemplate = true

        button.image = self.buttonImage
        button.action = #selector(mainMenuItemClicked)
        button.sendAction(on: [.leftMouseDown, .rightMouseDown])

        // https://github.com/Mortennn/Dozer
        // 把菜单左边的菜单都隐藏
        self.hideStatusBar()

        self.popover.contentViewController = MainViewController.freshController()
    }
    
    deinit {
        print("main status item has been deallocated")
    }
    
    func showStatusBar() {
        self.statusItem?.length = showLength
    }
    
    func hideStatusBar() {
        self.statusItem?.length = hideLength
    }
    
    func toggleStatusBar() {
        if isShown {
            hideStatusBar()
        } else {
            showStatusBar()
        }
    }
    
    @IBAction func mainMenuItemClicked(_ sender: Any?) {
        guard  let currentEvent = NSApp.currentEvent else {
            NSLog("read current event failed")
            return
        }
        if currentEvent.type == .rightMouseDown {
            handleRightClick()
        } else if currentEvent.type == .leftMouseDown {
            handleLeftClick()
        }
    }
    
    internal func handleLeftClick() {
        self.togglePopover(nil)
    }
    
    internal func handleRightClick() {
        self.toggleStatusBar()
    }
    
    var isShown: Bool {
        get {
            return (statusItem?.length == showLength)
        }
    }
    
    internal func handleMouseMoved(mouseLocation:NSPoint) {
        if isMouseInStatusBar(with: mouseLocation) && listenForMouseExit.shared.mouseHasExited {
            self.showStatusBar()
            listenForMouseExit.shared.mouseHasExited = false
        } else if !isMouseInStatusBar(with: mouseLocation) {
            listenForMouseExit.shared.mouseHasExited = true
        }
    }
    
    func isMouseInStatusBar(with mouseLocation:NSPoint) -> Bool {
        let statusBarHeight = NSStatusBar.system.thickness
        for screen in NSScreen.screens {
            var frame = screen.frame
            frame.origin.y = frame.origin.y + frame.height - statusBarHeight - 2
            frame.size.height = statusBarHeight + 3
            if frame.contains(mouseLocation) {
                return true
            }
        }
        return false
    }
}

class listenForMouseExit {
    static let shared = listenForMouseExit()
    var mouseHasExited:Bool
    private init() {
        mouseHasExited = false
    }
}


