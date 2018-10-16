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
import Vision

// https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/capturing_still_and_live_photos
// https://www.youtube.com/watch?v=zFfCt-ehK9A
class PhotoHelper: NSObject {
    // https://gorillalogic.com/blog/how-to-build-a-face-recognition-app-in-ios-using-coreml-and-turi-create-part-1/
    let faceDetection = VNDetectFaceRectanglesRequest()
    let faceDetectionRequest = VNSequenceRequestHandler()
    var faceClassificationRequest: VNCoreMLRequest!
    var lastObservation: VNFaceObservation?
    
    public let session = AVCaptureSession()
    lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        var previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }()
    
    var sampleCounter = 0
    let requiredSamples = 1 // 需要采集的样本数
    var faceImages = [NSImage]()
//    let stillImageOutput: AVCaptureStillImageOutput
    var isIdentifiyingPeople = false
    // https://github.com/Willjay90/AppleFaceDetection
    private var requests = [VNRequest]() // you can do multiple requests at the same time
    var faceDetectionReuqest: VNRequest!
    var faceDir: URL?
    var timer: Timer?
    
    weak var delegate: PhotoUIDelegate?
    weak var matchDelegate: PhotoMatchDelegate?
    
    init(delegate: PhotoUIDelegate?, matchDelegate: PhotoMatchDelegate?) {
        self.delegate = delegate
        self.matchDelegate = matchDelegate
//        self.stillImageOutput = AVCaptureStillImageOutput()
        super.init()
        
        let desktopUrl = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        self.faceDir = desktopUrl.appendingPathComponent("face", isDirectory: true)
//        self.session.sessionPreset = .photo
//
//        if self.session.canAddInput(input) {
//            self.session.addInput(input)
//        }
//
//        if view != nil {
//            let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
//            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//            previewLayer.frame = view!.bounds
//            view!.wantsLayer = true
//            view!.layer!.addSublayer(previewLayer)
//        }
//
//        self.stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
//        guard self.session.canAddOutput(self.stillImageOutput) else {
//            NSLog("Can not add photo output!")
//            return
//        }
//        self.session.addOutput(self.stillImageOutput)
        
//         https://medium.freecodecamp.org/ios-coreml-vision-image-recognition-3619cf319d0b
//        let captureOutput = AVCaptureVideoDataOutput()
//        self.captureSession.addOutput(captureOutput)
//        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        configureAVSession()
        configurePreviewLayer()
    }
    
    func configureAVSession() {
        let devices = AVCaptureDevice.devices(for: .video)
        guard let captureDevice = devices.first else {
            preconditionFailure("No camera device found")
        }
        print(captureDevice.localizedName)
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            preconditionFailure("unable to get input from AVDevice")
        }
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        output.alwaysDiscardsLateVideoFrames = true
        
        session.beginConfiguration()
        
        if session.canAddInput(deviceInput) {
           session.addInput(deviceInput)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        
        let queue = DispatchQueue(label: "output.queue")
        output.setSampleBufferDelegate(self, queue: queue)
    }
    
    func configurePreviewLayer() {
        if let layer = previewLayer,
            let view = delegate?.getCameraView() {
            layer.frame = view.bounds
            view.wantsLayer = true
            view.layer?.addSublayer(layer)
        }
    }
    
    func start() {
        try? FileManager.default.removeItem(at: self.faceDir!)
        
        faceImages.removeAll()
        // https://github.com/opencv/opencv/issues/12763
        if !session.isRunning {
            session.startRunning()
        }
        // 30秒后关摄像头
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false) {_ in
            self.stop()
            print("after 30 seconds")
            self.matchDelegate?.isMe(isMe: false)
        }
    }
    
    func capture(imageView: NSImageView?) {
//        if let videoConnection = self.stillImageOutput.connection(with: AVMediaType.video) {
//            self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { (imageDataSampleBuffer, error) in
//                guard imageDataSampleBuffer != nil else {
//                    return
//                }
//                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
//                let image = NSImage.init(data: imageData!)
//                if imageView != nil {
//                    DispatchQueue.main.async {
//                        imageView!.image = image
//                    }
//                }
//                let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//                let destinationURL = desktopURL.appendingPathComponent("lock.png")
//                if (image?.pngWrite(to: destinationURL))! {
//                    print("lock image saved")
//                }
//            }
//        }
    }
    
    func dumpImage(image: NSImage, fileName: String) {
        try? FileManager.default.createDirectory(at: self.faceDir!, withIntermediateDirectories: true, attributes: nil)
        let destinationUrl = faceDir!.appendingPathComponent("\(fileName).png")
        if image.pngWrite(to: destinationUrl) {
            print("\(fileName) saved")
        }
    }
    
    func stop() {
        if session.isRunning {
            session.stopRunning()
        }
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}

extension PhotoHelper: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let attachments = CMCopyDictionaryOfAttachments(allocator: kCFAllocatorDefault, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate) as? [CIImageOption: Any] else {
                return
        }
        let ciImage = CIImage(cvImageBuffer: pixelBuffer, options: attachments)
        // rotate
//        let ciImageWithOrientation = ciImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.leftMirror.rawValue))

        detectFace(on: ciImage)
    }
    
    func detectFace(on image: CIImage) {
        try? faceDetectionRequest.perform([faceDetection], on: image)

        guard let faceObservation = (faceDetection.results as? [VNFaceObservation])?.first else {
            // no face detected, remove all rectangles on the screen
            DispatchQueue.main.async {
                self.delegate?.removeFaceRectangles()
            }
            return
        }

//        let croppedImage = image.cropped(to: faceObservation.boundingBox)
        let all = (CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])?.features(in: image) as? [CIFaceFeature])?.first
        let croppedImage = image.cropped(to: (all?.bounds)!)

        if isIdentifiyingPeople {
            let handler = VNImageRequestHandler(ciImage: croppedImage, orientation: .up)
            self.lastObservation = faceObservation
            try? handler.perform([self.faceClassificationRequest])
        } else {
//            let context = CIContext()
//            guard let faceImage = context.createCGImage(croppedImage, from: croppedImage.extent) else {
//                return
//            }
            sampleCounter += 1
            let tickSample = 2
            // grab a sample every tickSample samples
            if sampleCounter % tickSample == 0 {
                let nsImage = croppedImage.nsImage
                faceImages.append(nsImage)
                DispatchQueue.main.async {
//                    let nsImage = NSImage(cgImage: faceImage, size: NSZeroSize)
                    self.dumpImage(image: nsImage, fileName: "lock-\(self.sampleCounter / tickSample)")
                    self.delegate?.showImage(image: nsImage)
                }
                if faceImages.count == requiredSamples {
                    DispatchQueue.main.async {
                        self.delegate?.faceIdentified(faces: self.faceImages)
                    }
                    stop()
                    self.comparePhoto()
                }
            }
            DispatchQueue.main.async {
                self.delegate?.setProgress(value: Double(self.faceImages.count) / Double(self.requiredSamples) * 100)
            }
        }
    }
    
    func comparePhoto() {
        // https://github.com/ageitgey/face_recognition
        let sourcePath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".macueqt", isDirectory: true).appendingPathComponent("face_known", isDirectory: true)
        print(sourcePath.path)
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let targetPath = desktopURL.appendingPathComponent("face", isDirectory: true)
        print(targetPath.path)
        let process = Process()
        process.launchPath = "/usr/local/bin/face_recognition"
        process.arguments = ["--show-distance", "true", sourcePath.path, targetPath.path]
        var environment = ProcessInfo.processInfo.environment
        environment["LC_ALL"] = "zh_CN.UTF-8"
        environment["LANG"] = "zh_CN.UTF-8"
        process.environment = environment
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = String(data: data, encoding: .utf8)!
        
        let strings = output.components(separatedBy: ",")
        if strings.count == 3 {
            if strings[1] == "ueqt" {
                print("it's me!")
                self.matchDelegate?.isMe(isMe: true)
            } else {
                print("it's not me!")
                self.matchDelegate?.isMe(isMe: false)
            }
            print("confidence: \(strings[2])")
        }
    }
}

protocol PhotoMatchDelegate: class {
    func isMe(isMe: Bool)
}

protocol PhotoUIDelegate: class {
    func removeFaceRectangles()
    func faceIdentified(faces: [NSImage])
    func setProgress(value: Double)
    func getCameraView() -> NSView
    func showImage(image: NSImage)
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

extension CIImage {
    var nsImage: NSImage {
        let imageRep = NSCIImageRep(ciImage: self)
        let nsImage = NSImage(size: imageRep.size)
        nsImage.addRepresentation(imageRep)
        return nsImage
    }
}

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
    var ciImage: CIImage? {
        guard let data = tiffRepresentation else { return nil }
        return CIImage(data: data)
    }
    var faces: [NSImage] {
        guard let ciImage = ciImage else { return [] }
        return (CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])?
            .features(in: ciImage) as? [CIFaceFeature])?
            .map {
                let ciimage = ciImage.cropped(to: $0.bounds)  // Swift 3 use cropping(to:)
                let imageRep = NSCIImageRep(ciImage: ciimage)
                let nsImage = NSImage(size: imageRep.size)
                nsImage.addRepresentation(imageRep)
                return nsImage
            }  ?? []
    }
}

