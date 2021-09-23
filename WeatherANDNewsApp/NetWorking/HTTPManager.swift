//
//  HTTPManager.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 23.09.21.
//

import UIKit
import Alamofire

class HTTPManager {
    static let shared = HTTPManager()
    
    func getCurrentWeather(for city: String, _ onCompletion: @escaping (CurrentWeatherMain?) -> Void) {
        
        AF.request("https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=5191046f25842380a185c9d77f29dc49").response { response in
            guard let data = response.data,
                  let currentWeather = ParseManager.shared.parseCurrentWeather(from: data) else {
                onCompletion (nil)
                return
            }
            onCompletion (currentWeather)
        }
    }
}
