//
//  CurrentWeather.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 12.09.21.
//

import UIKit

class CurrentWeatherDescription {
    var weatherID: Int
    var shortNameOfWeather: String
    var descriptionOfWeather: String
    
    init(weatherID: Int, shortNameOfWeather: String, descriptionOfWeather: String) {
        self.weatherID = weatherID
        self.shortNameOfWeather = shortNameOfWeather
        self.descriptionOfWeather = descriptionOfWeather
    }
}
