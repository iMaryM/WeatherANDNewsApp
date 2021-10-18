//
//  WeatherInfoDB.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 18.10.21.
//

import UIKit
import RealmSwift

class WeatherInfoDB: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var shortNameOfWeather: String = ""
    @Persisted var descriptionOfWeather: String = ""
    @Persisted var imageName: String = ""
    @Persisted var currentTemperature: Double = 0.0
    
    convenience init(shortNameOfWeather: String, descriptionOfWeather: String, imageName: String, currentTemperature: Double) {
        self.init()
        self.shortNameOfWeather = shortNameOfWeather
        self.descriptionOfWeather = descriptionOfWeather
        self.imageName = imageName
        self.currentTemperature = currentTemperature
    }
}
