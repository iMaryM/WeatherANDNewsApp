//
//  CurrentWeatherName.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 16.09.21.
//

import UIKit

class CurrentWeatherMain {
    
    var arrayOfCurrentWeatherDescription: [CurrentWeatherDescription]
    var currentTemperature: Double
    var feelsTemperature: Double
    var atmosphericPressure: Int
    var humidity: Int
    var maxTemperature: Double
    var minTemperature: Double
    var sunrise: Date
    var sunset: Date
    var windSpeed: Double
    var windDirection: Int
    
    init(arrayOfCurrentWeatherDescription: [CurrentWeatherDescription], currentTemperature: Double, feelsTemperature: Double, atmosphericPressure: Int, humidity: Int, maxTemperature: Double, minTemperature: Double, sunrise: Date, sunset: Date, windSpeed: Double, windDirection: Int) {
        self.arrayOfCurrentWeatherDescription = arrayOfCurrentWeatherDescription
        self.currentTemperature = currentTemperature
        self.feelsTemperature = feelsTemperature
        self.atmosphericPressure = atmosphericPressure
        self.humidity = humidity
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.sunrise = sunrise
        self.sunset = sunset
        self.windSpeed = windSpeed
        self.windDirection = windDirection
    }
}
