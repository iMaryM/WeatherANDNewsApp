//
//  ViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 12.09.21.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet weak var currentWeatherView: UIVisualEffectView!
    @IBOutlet weak var currentWeatherBlur: UIVisualEffectView!
    @IBOutlet weak var WeatherImageView: UIImageView!
    
    @IBOutlet weak var shortNameOfWeatherLabel: UILabel!
    @IBOutlet weak var descriptionOfWeatherLabel: UILabel!
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var feelsWeatherLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var atmosphericPressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    let currentDate = Date()
    
    let URLString = "https://api.openweathermap.org/data/2.5/weather?q=Minsk&appid=5191046f25842380a185c9d77f29dc49"
    
    var arrayCurrentWeather: [CurrentWeatherDescription] = []
    var currentWeatherMain: CurrentWeatherMain?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CurrentDate - \(currentDate)")
        
        currentWeatherView.clipsToBounds = true
        currentWeatherView.layer.cornerRadius = currentWeatherView.frame.height / 2.0
        
        currentWeatherBlur.clipsToBounds = true
        currentWeatherBlur.layer.cornerRadius = currentWeatherBlur.frame.height / 2.0
        
        getWeatherDescriptionData()
        
            
    }

    func getWeatherDescriptionData() {
        
        guard let url = URL(string: URLString) else {return}
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {return}
            
            guard let weatherDescription = json["weather"] as? [[String: Any]] else {return}
            
            for value in weatherDescription {
                guard let main = value["main"] as? String,
                      let description = value["description"] as? String,
                      let id = value["id"] as? Int else {
                    return
                }
                
                self.arrayCurrentWeather.append(CurrentWeatherDescription(weatherID: id, shortNameOfWeather: main, descriptionOfWeather: description))
            }
            
            guard let weatherMain = json["main"] as? [String: Any] else {return}
            
            guard let currentTemperature = weatherMain["temp"] as? Double,
                  let feelsTemperature = weatherMain["feels_like"] as? Double,
                  let atmosphericPressure = weatherMain["pressure"] as? Int,
                  let humidity = weatherMain["humidity"] as? Int,
                  let maxTemperature = weatherMain["temp_max"] as? Double,
                  let minTemperature = weatherMain["temp_min"] as? Double else {
                return
            }
            
            guard let sys = json["sys"] as? [String: Any] else {
                return
            }
            
            guard let sunrise = sys["sunrise"] as? Int,
                  let sunset = sys["sunset"] as? Int else {
                return
            }
            
            self.currentWeatherMain = CurrentWeatherMain(currentTemperature: currentTemperature, feelsTemperature: feelsTemperature, atmosphericPressure: atmosphericPressure, humidity: humidity, maxTemperature: maxTemperature, minTemperature: minTemperature, sunrise: Date(timeIntervalSince1970: TimeInterval(sunrise)), sunset: Date(timeIntervalSince1970: TimeInterval(sunset)))
            
            DispatchQueue.main.async  {
                for value in self.arrayCurrentWeather {
                    self.shortNameOfWeatherLabel.text = value.shortNameOfWeather
                    self.descriptionOfWeatherLabel.text = value.descriptionOfWeather
                    if value.weatherID == 800 {
                        self.WeatherImageView.image = UIImage(named: "diego-ph-5LOhydOtTKU-unsplash")
                        self.WeatherImageView.contentMode = .scaleAspectFill
                    }
                    
                    if value.weatherID == 804 {
                        self.WeatherImageView.image = UIImage(named: "clouds")
                        self.WeatherImageView.contentMode = .scaleAspectFill
                    }
                    
                    if value.weatherID == 500 {
                        self.WeatherImageView.image = UIImage(named: "rain")
                        self.WeatherImageView.contentMode = .scaleAspectFill
                    }
                    
                }
                
                guard let currentWeatherMain = self.currentWeatherMain else {return}
                
                let currentTemperature = currentWeatherMain.currentTemperature - 273.15
                let feelsTemperature = currentWeatherMain.feelsTemperature - 273.15
                let maxTemperature = currentWeatherMain.maxTemperature - 273.15
                let minTemperature = currentWeatherMain.minTemperature - 273.15
                let atmosphericPressure = Double(currentWeatherMain.atmosphericPressure) * 0.75006375541921
                let sunrise = currentWeatherMain.sunrise.getCurrentDate(from: "HH:mm")
                let sunset = currentWeatherMain.sunset.getCurrentDate(from: "HH:mm")
                
                
                self.currentTemperatureLabel.text = currentTemperature > 0 ? "+\(Int(currentTemperature))°C" : "\(Int(currentTemperature))°C"
                
                self.feelsWeatherLabel.text = currentTemperature > 0 ? "Feels like +\(Int(feelsTemperature))°C" : "Feels like \(Int(feelsTemperature))°C"
                
                self.maxTemperatureLabel.text = maxTemperature > 0 ? "Max +\(Int(maxTemperature))°C" : "Max \(Int(maxTemperature))°C"
                
                self.minTemperatureLabel.text = minTemperature > 0 ? "Min +\(Int(minTemperature))°C" : "Min \(Int(minTemperature))°C"
                
                self.atmosphericPressureLabel.text = "\(Int(atmosphericPressure)) mmHg"
                
                self.humidityLabel.text = "\(currentWeatherMain.humidity)%"
                
                self.sunriseLabel.text = "sunrise: \(sunrise)"
                
                self.sunsetLabel.text = "sunset: \(sunset)"
            }

        }
        
        session.resume()
        
    }

}

