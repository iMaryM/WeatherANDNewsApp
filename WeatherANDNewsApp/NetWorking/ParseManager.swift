//
//  ParseManager.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 23.09.21.
//

import UIKit

class ParseManager {
    static let shared = ParseManager()
    
    func parseCurrentWeather(from data: Data) -> CurrentWeatherMain? {
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {return nil}
        
        guard let weatherDescription = json["weather"] as? [[String: Any]] else {return nil}
        
        var arrayOfCurrentWeatherDescription: [CurrentWeatherDescription] = []
        
        for value in weatherDescription {
            guard let main = value["main"] as? String,
                  let description = value["description"] as? String,
                  let id = value["id"] as? Int else {return nil}
            
            arrayOfCurrentWeatherDescription.append(CurrentWeatherDescription(weatherID: id, shortNameOfWeather: main, descriptionOfWeather: description))
        }
        
        guard let weatherMain = json["main"] as? [String: Any] else {return nil}
        
        guard let currentTemperature = weatherMain["temp"] as? Double,
              let feelsTemperature = weatherMain["feels_like"] as? Double,
              let atmosphericPressure = weatherMain["pressure"] as? Int,
              let humidity = weatherMain["humidity"] as? Int,
              let maxTemperature = weatherMain["temp_max"] as? Double,
              let minTemperature = weatherMain["temp_min"] as? Double else {return nil}
        
        guard let sys = json["sys"] as? [String: Any] else {return nil}
        
        guard let sunrise = sys["sunrise"] as? Int,
              let sunset = sys["sunset"] as? Int else {return nil}
        
        guard let wind = json["wind"] as? [String: Any] else {return nil}
        
        guard let windSpeed = wind["speed"] as? Double,
              let windDirection = wind["deg"] as? Int else {return nil}
        
        return CurrentWeatherMain(arrayOfCurrentWeatherDescription: arrayOfCurrentWeatherDescription, currentTemperature: currentTemperature, feelsTemperature: feelsTemperature, atmosphericPressure: atmosphericPressure, humidity: humidity, maxTemperature: maxTemperature, minTemperature: minTemperature, sunrise: Date(timeIntervalSince1970: TimeInterval(sunrise)), sunset: Date(timeIntervalSince1970: TimeInterval(sunset)), windSpeed: windSpeed, windDirection: windDirection)
    }
}
