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
            
            switch value.weatherID {
            case 200, 201, 202, 210, 211, 212, 221, 230, 231, 232:
                self.WeatherImageView.image = UIImage(named: "thunderstorm_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 300...302, 310...314, 321:
                self.WeatherImageView.image = UIImage(named: "drizzle_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 500...504, 511, 520...522, 531:
                self.WeatherImageView.image = UIImage(named: "rain_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 600...602, 611...616, 620...622:
                self.WeatherImageView.image = UIImage(named: "snow_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 701:
                self.WeatherImageView.image = UIImage(named: "mist_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 711:
                self.WeatherImageView.image = UIImage(named: "smoke_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 721:
                self.WeatherImageView.image = UIImage(named: "haze_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 731, 761:
                self.WeatherImageView.image = UIImage(named: "dust_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 741:
                self.WeatherImageView.image = UIImage(named: "fog_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 751:
                self.WeatherImageView.image = UIImage(named: "sand_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 762:
                self.WeatherImageView.image = UIImage(named: "ash_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 771:
                self.WeatherImageView.image = UIImage(named: "squall_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 781:
                self.WeatherImageView.image = UIImage(named: "tornado_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 800:
                self.WeatherImageView.image = UIImage(named: "clear_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            case 801...804:
                self.WeatherImageView.image = UIImage(named: "сlouds_day")
                self.WeatherImageView.contentMode = .scaleAspectFill
            default: break
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

