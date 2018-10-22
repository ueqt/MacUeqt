//
//  CalendarDayItem.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/19.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

class CalendarDayItem: NSCollectionViewItem {

    @IBOutlet weak var lunarTextField: NSTextField!

    // https://github.com/ekreutz/CornerCal
    public func setHasRedBackground(hasRedBackground: Bool) {
        if (hasRedBackground) {
            view.layer?.cornerRadius = (view.layer?.frame.width)! / 2
            view.layer?.backgroundColor = NSColor.red.cgColor
            textField?.textColor = NSColor.white
        } else {
            view.layer?.cornerRadius = 0
            view.layer?.backgroundColor = CGColor.clear
            textField?.textColor = NSColor.textColor
        }
    }

    public func setPartlyTransparent(partlyTransparent: Bool) {
        view.layer?.opacity = partlyTransparent ? 0.5 : 1.0
    }

    public func setBold(bold: Bool) {
        let fontSize = (textField?.font?.pointSize)!
        if bold {
            textField?.font = NSFont.boldSystemFont(ofSize: fontSize)
        } else {
            textField?.font = NSFont.systemFont(ofSize: fontSize)
        }
    }

    public func setText(text: String) {
        textField?.stringValue = text
    }

    public func setTooltip(text: String) {
        textField?.toolTip = text
    }

    public func setLunar(text: String) {
        lunarTextField.stringValue = text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        textField?.alignment = NSTextAlignment.center
    }
}
