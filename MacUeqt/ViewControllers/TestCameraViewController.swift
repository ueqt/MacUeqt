//
//  MainView.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/7.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa
import ServiceManagement
import Vision
import AVFoundation

class TestCameraViewController: NSViewController {
    var photo: PhotoHelper? = nil
    var faceRectangles = [NSView]()
    
    @IBOutlet weak var previewView: VideoPreviewView!
    @IBOutlet weak var captureImage: NSImageView!
    @IBOutlet weak var progressView: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photo = PhotoHelper(delegate: self, matchDelegate: nil)
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

extension TestCameraViewController: PhotoUIDelegate {
    func removeFaceRectangles() {
        for faceRectangle in self.faceRectangles {
            faceRectangle.removeFromSuperview()
        }
        self.faceRectangles.removeAll()
    }
    
    func faceIdentified(faces: [NSImage]) {
        self.view.window?.close()
    }
    
    func setProgress(value: Double) {
        self.progressView?.doubleValue = value
    }
    
    func getCameraView() -> NSView {
        return self.previewView
    }
    
    func showImage(image: NSImage) {
        self.captureImage.image = image
    }
}
