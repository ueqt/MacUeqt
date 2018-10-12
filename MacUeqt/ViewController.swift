//
//  ViewController.swift
//  MacUeqt
//
//  Created by ueqt on 2018/9/30.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBAction func lockScreen(_ sender: Any) {
        let p = Process()
        p.launchPath = "/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession"
        p.arguments = ["-suspend"]
        p.launch()
    }
    @IBAction func openIterm(_ sender: Any) {
        let openIterm = OpenIterm()
        openIterm.run()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("MacUeqt launched from %@", Bundle.main.bundlePath as NSString)
//
//        let url = URL(string: "https://www.bing.com")
//        let request = URLRequest(url: url!)
//        webView.load(request)

//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            NSApplication.shared.terminate(self)
//        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

