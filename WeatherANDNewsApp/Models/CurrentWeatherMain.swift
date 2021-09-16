//
//  CurrentWeatherName.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 16.09.21.
//

import UIKit

class CurrentWeatherMain {
    var currentTemperature: Double
    var feelsTemperature: Double
    var atmosphericPressure: Int
    var humidity: Int
    var maxTemperature: Double
    var minTemperature: Double
    var sunrise: Date
    var sunset: Date
    
    init(currentTemperature: Double, feelsTemperature: Double, atmosphericPressure: Int, humidity: Int, maxTemperature: Double, minTemperature: Double, sunrise: Date, sunset: Date) {
        self.currentTemperature = currentTemperature
        self.feelsTemperature = feelsTemperature
        self.atmosphericPressure = atmosphericPressure
        self.humidity = humidity
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.sunrise = sunrise
        self.sunset = sunset
    }
}
