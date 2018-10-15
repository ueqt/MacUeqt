//
//  MainView.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/7.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa
import ServiceManagement

class TestCameraViewController: NSViewController {
    var photo: PhotoHelper? = nil

    @IBOutlet weak var videoView: VideoCustomView!
    @IBOutlet weak var captureImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photo = PhotoHelper(view: self.videoView)
    }
}

extension TestCameraViewController {
    // MARK: Actions
    
    @IBAction func captureAll(_ sender: Any) {
        self.photo?.start()
        sleep(1)
        self.photo?.capture(imageView: self.captureImage)
//        self.photo?.capture(imageView: nil)
        sleep(1)
        self.photo?.stop()
    }
    @IBAction func startCamera(_ sender: Any) {
        self.photo?.start()
    }
    @IBAction func captureCamera(_ sender: Any) {
        self.photo?.capture(imageView: self.captureImage)
    }
    @IBAction func stopCamera(_ sender: Any) {
        self.photo?.stop()
    }
}
