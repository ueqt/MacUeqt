//
//  StatusItemController.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/5.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject, WeatherApiDelegate{
    @IBOutlet weak var menuController: StatusMenuController!
    @IBOutlet weak var weatherView: WeatherView!
    // Make a status bar that has variable length (as opposed to being a standard square size)
    // -1 to indicate "variable length"
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var weatherMenuItem: NSMenuItem!
    var weather: WeatherApi! = nil
    
    override func awakeFromNib() {
        // Set the text that appears in the menu bar
        self.statusItem.button?.title = "Ueqt"
        let icon = NSImage(named: "Star")
        // image should be set as template so that it changes when the user sets the menu bar to a dark theme
        icon?.isTemplate = true
        icon?.size = NSSize(width: 20, height: 18)
        self.statusItem.button?.image = icon
//        self.statusItem.length = 70
        // Set the menu that should appear when the item is clicked
        self.statusItem.menu = self.menuController.menu
        
        self.weatherMenuItem = self.statusItem.menu?.item(withTitle: "日常")?.submenu?.item(withTitle: "Weather")
        self.weatherMenuItem.view = weatherView
        
        // update weather
        self.weather = WeatherApi(delegate: self)
        self.updateWeather()
    }
    
    @IBAction func finderOpenIterm(_ sender: Any) {
        let openIterm = OpenIterm()
        openIterm.run()
    }
    
    @IBAction func lifeWeather(_ sender: Any) {
        self.updateWeather()
    }
    
    func updateWeather() {
        weather.fetchWeather(query: "101020100")
    }
    
    func weatherDidUpdate(weather: Weather) {
//        NSLog(weather.description)
//        self.weatherMenuItem.title = weather.description
        self.weatherView.update(weather: weather)
    }
}
