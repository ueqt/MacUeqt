//
//  StatusBarViewController.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/12.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class StatusBarViewController: ViewController {
    
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var mainIcon: NSButton!
    private let mainPopover = NSPopover()
    
    override func viewDidLoad() {
        self.mainPopover.contentViewController = MainViewController.freshController(statusBarView: self)
        self.mainIcon.image?.isTemplate = true
        
        // update time
        let date = NSDate()
        self.timeLabel.stringValue = date.time()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {_ in
            let date = NSDate()
            self.timeLabel.stringValue = date.time()
        }
    }
    
    @IBAction func toggleMainPopover(_ sender: Any) {
        if self.mainPopover.isShown {
            self.closeMainPopover(sender: sender)
        } else {
            self.showMainPopover(sender: sender)
        }
    }
    
    func showMainPopover(sender: Any?) {
        self.mainPopover.show(relativeTo: self.mainIcon.bounds, of: self.mainIcon, preferredEdge: NSRectEdge.minY)
    }
    
    func closeMainPopover(sender: Any?) {
        self.mainPopover.performClose(sender)
    }
}

extension StatusBarViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> StatusBarViewController {
        // 1. Get a reference to Main.storyboard
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        // 2. Create a Scene identifier that matches the one set on ui
        let identifier = NSStoryboard.SceneIdentifier("StatusBarViewController")
        // 3. Instantiate MainViewController and return it
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? StatusBarViewController else {
            fatalError("Why cant i find StatusBarViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
