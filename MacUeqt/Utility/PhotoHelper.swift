//
//  PhotoHelper.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/14.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation
//import Vision

// https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/capturing_still_and_live_photos
// https://www.youtube.com/watch?v=zFfCt-ehK9A
class PhotoHelper: NSObject {
    let captureSession: AVCaptureSession
    let stillImageOutput: AVCaptureStillImageOutput
    
    init(view: NSView?) {
        self.captureSession = AVCaptureSession()
        self.stillImageOutput = AVCaptureStillImageOutput()
        super.init()
        self.captureSession.sessionPreset = .photo
        let devices = AVCaptureDevice.devices(for: .video)
        guard let captureDevice = devices.first else {
            NSLog("No camera device!")
            return
        }
        NSLog(captureDevice.localizedName)
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            NSLog("Can not init camera input!")
            return
        }
        if self.captureSession.canAddInput(input) {
            self.captureSession.addInput(input)
        }
        
        if view != nil {
            let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.frame = view!.bounds
            view!.wantsLayer = true
            view!.layer!.addSublayer(previewLayer)
        }
        
        self.stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
        guard self.captureSession.canAddOutput(self.stillImageOutput) else {
            NSLog("Can not add photo output!")
            return
        }
        self.captureSession.addOutput(self.stillImageOutput)
        
        // https://medium.freecodecamp.org/ios-coreml-vision-image-recognition-3619cf319d0b
//        let captureOutput = AVCaptureVideoDataOutput()
//        self.captureSession.addOutput(captureOutput)
//        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
    }
    
    func start() {
        // https://github.com/opencv/opencv/issues/12763
        if !self.captureSession.isRunning {
            self.captureSession.startRunning()
        }
    }
    
    func capture(imageView: NSImageView?) {
        if let videoConnection = self.stillImageOutput.connection(with: AVMediaType.video) {
            self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { (imageDataSampleBuffer, error) in
                guard imageDataSampleBuffer != nil else {
                    return
                }
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                let image = NSImage.init(data: imageData!)
                if imageView != nil {
                    DispatchQueue.main.async {
                        imageView!.image = image
                    }
                }
                let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
                let destinationURL = desktopURL.appendingPathComponent("lock.png")
                if (image?.pngWrite(to: destinationURL))! {
                    print("lock image saved")
                }
            }
        }
    }
    
    func stop() {
        if self.captureSession.isRunning {
            self.captureSession.stopRunning()
        }
    }
}
//
//extension PhotoHelper: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
//        let image = NSImage.init(data: imageData!)
//        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//        let destinationURL = desktopURL.appendingPathComponent("lock.png")
//        if (image?.pngWrite(to: destinationURL))! {
//            print("lock image saved")
//        }
////        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
////        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
////            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
////            guard let Observation = results.first else { return }
////
////            DispatchQueue.main.async(execute: {
////                self.label.text = "\(Observation.identifier)"
////                print(Observation.confidence)
////            })
////        }
////        guard let pixelBuffer: CVPixelBuffer = sampleBuffer.imageBuffer else { return }
////
////        // executes request
////        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//    }
//}

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil}
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            NSLog(error as! String)
            return false
        }
    }
}

