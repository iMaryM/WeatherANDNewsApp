//
//  ViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 12.09.21.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UIButton!
    
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
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let currentDate = Date()
    
    var addedCity = ""
    
    var arrayCurrentWeather: [CurrentWeatherDescription] = []
    var currentWeatherMain: CurrentWeatherMain?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.setTitle(addedCity, for: .normal)
        
        currentWeatherView.clipsToBounds = true
        currentWeatherView.layer.cornerRadius = currentWeatherView.frame.height / 2.0
        
        currentWeatherBlur.clipsToBounds = true
        currentWeatherBlur.layer.cornerRadius = currentWeatherBlur.frame.height / 2.0
        
        getWeatherDescriptionData()
            
    }

    func getWeatherDescriptionData() {
        
        let URLString = "https://api.openweathermap.org/data/2.5/weather?q=\(addedCity)&appid=5191046f25842380a185c9d77f29dc49"
        
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
            
            guard let wind = json["wind"] as? [String: Any] else { return }
            
            guard let windSpeed = wind["speed"] as? Double,
                  let windDirection = wind["deg"] as? Int else { return }
            
            self.currentWeatherMain = CurrentWeatherMain(currentTemperature: currentTemperature, feelsTemperature: feelsTemperature, atmosphericPressure: atmosphericPressure, humidity: humidity, maxTemperature: maxTemperature, minTemperature: minTemperature, sunrise: Date(timeIntervalSince1970: TimeInterval(sunrise)), sunset: Date(timeIntervalSince1970: TimeInterval(sunset)), windSpeed: windSpeed, windDirection: windDirection)
            
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
                let windDirection = currentWeatherMain.windDirection
                
                self.currentTemperatureLabel.text = currentTemperature > 0 ? "+\(Int(currentTemperature))°C" : "\(Int(currentTemperature))°C"
                
                self.feelsWeatherLabel.text = currentTemperature > 0 ? "Feels like +\(Int(feelsTemperature))°C" : "Feels like \(Int(feelsTemperature))°C"
                
                self.maxTemperatureLabel.text = maxTemperature > 0 ? "Max +\(Int(maxTemperature))°C" : "Max \(Int(maxTemperature))°C"
                
                self.minTemperatureLabel.text = minTemperature > 0 ? "Min +\(Int(minTemperature))°C" : "Min \(Int(minTemperature))°C"
                
                self.atmosphericPressureLabel.text = "\(Int(atmosphericPressure)) mmHg"
                
                self.humidityLabel.text = "\(currentWeatherMain.humidity)%"
                
                self.sunriseLabel.text = "sunrise: \(sunrise)"
                
                self.sunsetLabel.text = "sunset: \(sunset)"
                
                switch windDirection {
                case 0: self.windLabel.text = "N wind \(currentWeatherMain.windSpeed) m/s"
                case 1...89: self.windLabel.text = "NE wind \(currentWeatherMain.windSpeed) m/s"
                case 90: self.windLabel.text = "E wind \(currentWeatherMain.windSpeed) m/s"
                case 91...179: self.windLabel.text = "SE wind \(currentWeatherMain.windSpeed) m/s"
                case 180: self.windLabel.text = "S wind \(currentWeatherMain.windSpeed) m/s"
                case 181...269: self.windLabel.text = "SW wind \(currentWeatherMain.windSpeed) m/s"
                case 270: self.windLabel.text = "W wind \(currentWeatherMain.windSpeed) m/s"
                case 271...359: self.windLabel.text = "NW wind \(currentWeatherMain.windSpeed) m/s"
                case 360: self.windLabel.text = "N wind \(currentWeatherMain.windSpeed) m/s"
                default:
                    break
                }
                
                self.timeLabel.text = "\(self.currentDate.getCurrentDate(from: "E HH:mm"))"
            }

        }
        
        session.resume()
        
    }
    
    @IBAction func addCity(_ sender: UIButton) {
        guard let locationViewController = getViewController(from: "Location", and: "LocationViewController") as? LocationViewController else {return}
        locationViewController.arrayCurrentWeather = arrayCurrentWeather
        locationViewController.addedCity = addedCity
        locationViewController.modalPresentationStyle = .fullScreen
        locationViewController.modalTransitionStyle = .coverVertical
        present(locationViewController, animated: true, completion: nil)
    }
}

