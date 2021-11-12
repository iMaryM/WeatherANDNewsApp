//
//  CurrentWeatherDescription.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 23.09.21.
//

import UIKit

class CurrentWeatherDescription {
    var weatherID: Int
    var shortNameOfWeather: String
    var descriptionOfWeather: String
    var imageName: String
    
    init(weatherID: Int, shortNameOfWeather: String, descriptionOfWeather: String, imageName: String) {
        self.weatherID = weatherID
        self.shortNameOfWeather = shortNameOfWeather
        self.descriptionOfWeather = descriptionOfWeather
        self.imageName = imageName
    }
}
