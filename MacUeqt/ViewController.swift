//
//  ViewController.swift
//  MacUeqt
//
//  Created by ueqt on 2018/9/30.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        let worker = AppWorker()
        worker.run()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NSApplication.shared.terminate(self)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

