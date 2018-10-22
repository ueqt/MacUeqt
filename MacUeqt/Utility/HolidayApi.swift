//
//  LunarExtensions.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/22.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation
import Cocoa

class HolidayApi {
    
    // https://github.com/CodingFarmer-Zhang/Calendar-Swift/blob/e1a874217d6bf2e3dda6e908f8f70111cac07734/Calendar/YYIndicateViewController.swift
    // 请求休假数据
    static func  getHolidays(httpArg: String, forYear : Bool, completionHandler: @escaping (_ results:NSMutableArray)->()) {
        let vocations = NSMutableArray()
        
        var req = URLRequest(url: URL(string: "http://apis.baidu.com/xiaogg/holiday/holiday?d=\(httpArg)")!)
        req.timeoutInterval = 6
        req.httpMethod = "GET"
        req.addValue("b2e3a5f4f78a94f62d2c173ec4589644", forHTTPHeaderField: "apikey")
        
        URLSession.shared.dataTask(with: req) { data, response, err in
            if let error = err {
                NSLog("holiday api error: \(error)")
            }

            if let d = data {
                if forYear {
                    let json = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as! NSDictionary
                    if let arr = json?[httpArg] {
                        vocations.addObjects(from: arr as! [AnyObject])
                        completionHandler(vocations)
                    }
                } else {
                    print(String(data: d, encoding: String.Encoding.utf8) ?? "")
                }
            }
        }.resume()
    }
}
