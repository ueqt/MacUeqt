//
//  MainView.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/7.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa
import ServiceManagement

class MainViewController: NSViewController {
    
    @IBOutlet weak var finderItermButton: NSButton!
    @IBOutlet weak var popupButton: NSButton!
    @IBOutlet var popupMenu: NSMenu!
    @IBOutlet weak var startAtLoginCheckMenu: NSMenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupButton.image?.isTemplate = true
        
        // start at login
        self.startAtLoginCheckMenu.state = UserDefaults.standard.bool(forKey: "startAtLogin") ? .on : .off
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        // 菜单跳转后关闭菜单
        AppDelegate.statusItemMain.closePopover(sender: sender)
    }
}

extension MainViewController {
    // MARK: Actions
    @IBAction func doPopupMenu(_ sender: NSButton) {
        NSMenu.popUpContextMenu(self.popupMenu!, with: NSApp.currentEvent!, for: self.popupButton)
    }
    
    @IBAction func doFinderIterm(_ sender: Any) {
        let openIterm = OpenIterm()
        openIterm.run()
        AppDelegate.statusItemMain.closePopover(sender: sender)
    }
    
    @IBAction func doFinderNewFile(_ sender: Any) {
        let newFile = NewFile()
        newFile.run()
        AppDelegate.statusItemMain.closePopover(sender: sender)
    }
    
    @IBAction func toggleStartAtLogin(_ sender: NSMenuItem) {
        let startAtLoginAppIdentifer = "ueqt.xu.MacUeqtStartAtLogin"
        let isAuto = !(sender.state == .on)
        if !SMLoginItemSetEnabled(startAtLoginAppIdentifer as CFString, isAuto) {
            NSLog("set login item failed")
        } else {
            UserDefaults.standard.set(isAuto, forKey: "startAtLogin")
            self.startAtLoginCheckMenu.state = isAuto ? .on : .off
        }
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
