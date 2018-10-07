//
//  Weather.swift
//  MacUeqt
//
//  Created by ueqt on 2018/10/5.
//  Copyright © 2018 Ueqt. All rights reserved.
//

import Foundation

class WeatherApi {
    var delegate: WeatherApiDelegate?
    
    let BASE_URL = "http://www.weather.com.cn/data/sk/"
    
    init(delegate: WeatherApiDelegate) {
        self.delegate = delegate
    }
    
    func fetchWeather(query: String) {
        // url-escape the query string we're passed
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: "\(BASE_URL)\(escapedQuery ?? "101020100").html")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, err in
            // first check for a hard error
            if let error = err {
                NSLog("weather api error: \(error)")
            }
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
//                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                    NSLog(dataString)
                    if let weather = self.weatherFromJSONData(data: data!) {
//                        NSLog("\(weather)")
                        self.delegate?.weatherDidUpdate(weather: weather)
                    }
                default:
                    NSLog("weather api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }.resume()
    }
    
    func weatherFromJSONData(data: Data) -> Weather? {
        typealias JSONDict = [String: AnyObject]
        let json: JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var mainDict = json["weatherinfo"] as! JSONDict
        return Weather(
            city: mainDict["city"] as! String,
            currentTemp: (mainDict["temp"] as! NSString).floatValue,
            conditions: mainDict["WD"] as! String,
            icon: "01d" // mainDict["icon"] as! String
        )
    }
}

struct Weather: CustomStringConvertible {
    var city: String
    var currentTemp: Float
    var conditions: String
    var icon: String
    
    var description: String {
        return "\(city): \(currentTemp)°C and \(conditions)"
    }
}

protocol WeatherApiDelegate {
    func weatherDidUpdate(weather: Weather)
}
