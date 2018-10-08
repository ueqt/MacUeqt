//
//  MainView.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/7.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    let delegate = NSApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var finderItermButton: NSButton!
    @IBOutlet weak var popupButton: NSButton!
    @IBOutlet var popupMenu: NSMenu!
}

extension MainViewController {
    // MARK: Actions
    @IBAction func doPopupMenu(_ sender: NSButton) {
        NSMenu.popUpContextMenu(self.popupMenu!, with: NSApp.currentEvent!, for: self.popupButton)
    }
    
    @IBAction func doFinderIterm(_ sender: Any) {
        let openIterm = OpenIterm()
        openIterm.run()
        self.delegate.closePopover(sender: sender)
    }
}

extension MainViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> MainViewController {
        // 1. Get a reference to Main.storyboard
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        // 2. Create a Scene identifier that matches the one set on ui
        let identifier = NSStoryboard.SceneIdentifier("MainViewController")
        // 3. Instantiate MainViewController and return it
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MainViewController else {
            fatalError("Why cant i find MainViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}