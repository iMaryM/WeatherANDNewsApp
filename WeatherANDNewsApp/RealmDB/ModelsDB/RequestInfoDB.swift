//
//  ReguestInfo.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 18.10.21.
//

import UIKit
import RealmSwift

class RequestInfoDB: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var date = Date()
    @Persisted var city: String = ""
    @Persisted var currentWeather: WeatherInfoDB?
    
    convenience init(date: Date, city: String, currentWeather: WeatherInfoDB?) {
        self.init()
        self.date = date
        self.city = city
        self.currentWeather = currentWeather
    }
}
