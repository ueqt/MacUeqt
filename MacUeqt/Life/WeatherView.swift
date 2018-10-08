//
//  WeatherView.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/5.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

class WeatherView: NSView {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var currentConditionsTextField: NSTextField!
    
    func update(weather: Weather) {
        // do UI updates on the main thread
        DispatchQueue.main.async {
            self.cityTextField.stringValue = weather.city
            self.currentConditionsTextField.stringValue = "\(weather.currentTemp)°C and \(weather.conditions)"
            self.imageView.image = NSImage(named: weather.icon)
        }
    }
}
