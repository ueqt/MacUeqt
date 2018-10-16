//
//  CustomView.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/14.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa
import Vision
import AVFoundation

class VideoPreviewView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let context = NSGraphicsContext.current?.cgContext
        context!.setFillColor(cyan: 0, magenta: 0,yellow: 0,black: 0,alpha: 0.50)
        context!.fill(dirtyRect)

        self.layer?.borderColor = NSColor.white.cgColor
        self.layer?.borderWidth = 2.0
    }
}

