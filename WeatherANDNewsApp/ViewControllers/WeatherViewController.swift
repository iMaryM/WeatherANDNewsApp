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
    
    var mainScreenImage = UIImageView()
    var visualBlur = UIBlurEffect()
    var visualBlurView = UIVisualEffectView()
    
    let currentDate = Date()
    
    var addedCity = ""
    var currentWeatherMain: CurrentWeatherMain?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let screenSize = UIScreen.main.bounds
        
        visualBlur = UIBlurEffect(style: .dark)
        visualBlurView = UIVisualEffectView(effect: visualBlur)
        visualBlurView.frame = screenSize
        visualBlurView.alpha = 0.7
        
        mainScreenImage = UIImageView(frame: screenSize)
        mainScreenImage.image = UIImage(named: "mainScreen_2")
        mainScreenImage.contentMode = .scaleAspectFill
        view.addSubview(mainScreenImage)
        view.addSubview(visualBlurView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 3, delay: 0, options: []) {
            self.mainScreenImage.alpha = 0
            self.visualBlurView.alpha = 0
        } completion: { _ in
            
        }
        
        cityLabel.setTitle(addedCity, for: .normal)
        
        currentWeatherView.clipsToBounds = true
        currentWeatherView.layer.cornerRadius = currentWeatherView.frame.height / 2.0
        
        currentWeatherBlur.clipsToBounds = true
        currentWeatherBlur.layer.cornerRadius = currentWeatherBlur.frame.height / 2.0
        
        getWeatherDescriptionData()
        
    }

    func getWeatherDescriptionData() {
        
        guard let currentWeather = currentWeatherMain else {return}
        
        for value in currentWeather.arrayOfCurrentWeatherDescription {
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
        
        let currentTemperature = currentWeather.currentTemperature - 273.15
        let feelsTemperature = currentWeather.feelsTemperature - 273.15
        let maxTemperature = currentWeather.maxTemperature - 273.15
        let minTemperature = currentWeather.minTemperature - 273.15
        let atmosphericPressure = Double(currentWeather.atmosphericPressure) * 0.75006375541921
        let sunrise = currentWeather.sunrise.getCurrentDate(from: "HH:mm")
        let sunset = currentWeather.sunset.getCurrentDate(from: "HH:mm")
        let windDirection = currentWeather.windDirection
        
        self.currentTemperatureLabel.text = currentTemperature > 0 ? "+\(Int(currentTemperature))°C" : "\(Int(currentTemperature))°C"
        
        self.feelsWeatherLabel.text = currentTemperature > 0 ? "Feels like +\(Int(feelsTemperature))°C" : "Feels like \(Int(feelsTemperature))°C"
        
        self.maxTemperatureLabel.text = maxTemperature > 0 ? "Max +\(Int(maxTemperature))°C" : "Max \(Int(maxTemperature))°C"
        
        self.minTemperatureLabel.text = minTemperature > 0 ? "Min +\(Int(minTemperature))°C" : "Min \(Int(minTemperature))°C"
        
        self.atmosphericPressureLabel.text = "\(Int(atmosphericPressure)) mmHg"
        
        self.humidityLabel.text = "\(currentWeather.humidity)%"
        
        self.sunriseLabel.text = "sunrise: \(sunrise)"
        
        self.sunsetLabel.text = "sunset: \(sunset)"
        
        switch windDirection {
        case 0: self.windLabel.text = "N wind \(currentWeather.windSpeed) m/s"
        case 1...89: self.windLabel.text = "NE wind \(currentWeather.windSpeed) m/s"
        case 90: self.windLabel.text = "E wind \(currentWeather.windSpeed) m/s"
        case 91...179: self.windLabel.text = "SE wind \(currentWeather.windSpeed) m/s"
        case 180: self.windLabel.text = "S wind \(currentWeather.windSpeed) m/s"
        case 181...269: self.windLabel.text = "SW wind \(currentWeather.windSpeed) m/s"
        case 270: self.windLabel.text = "W wind \(currentWeather.windSpeed) m/s"
        case 271...359: self.windLabel.text = "NW wind \(currentWeather.windSpeed) m/s"
        case 360: self.windLabel.text = "N wind \(currentWeather.windSpeed) m/s"
        default:
            break
        }
        
        self.timeLabel.text = "\(self.currentDate.getCurrentDate(from: "E HH:mm"))"
    }
    
    
    @IBAction func addCity(_ sender: UIButton) {
        guard let locationViewController = getViewController(from: "Location", and: "LocationViewController") as? LocationViewController else {return}
        locationViewController.currentWeatherMain = currentWeatherMain
        locationViewController.addedCity = addedCity
        locationViewController.completion = { city, weather in
            self.addedCity = city
            self.currentWeatherMain = weather
        }
        locationViewController.modalPresentationStyle = .fullScreen
        locationViewController.modalTransitionStyle = .coverVertical
        present(locationViewController, animated: true, completion: nil)
    }
}

