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
    
    let URLString = "https://api.openweathermap.org/data/2.5/weather?q=Minsk&appid=5191046f25842380a185c9d77f29dc49"
    
    var arrayCurrentWeather: [CurrentWeather] = []
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        
        currentWeatherView.clipsToBounds = true
        currentWeatherView.layer.cornerRadius = currentWeatherView.frame.height / 2.0
        
        currentWeatherBlur.clipsToBounds = true
        currentWeatherBlur.layer.cornerRadius = currentWeatherBlur.frame.height / 2.0
        
        getData()
        
    }

    func getData() {
        guard let url = URL(string: URLString) else {return}
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {return}
            
            print("Data - \(data)")
            print("Response - \(response)")
            print("Error - \(error)")
            
            print("JSON = \(json)")
            print("***********************")
            print()
            
            guard let weather = json["weather"] as? [[String: Any]] else {return}
            
            for value in weather {
                guard let main = value["main"] as? String,
                      let description = value["description"] as? String,
                      let id = value["id"] as? Int else {
                    return
                }
                
                self.arrayCurrentWeather.append(CurrentWeather(weatherID: id, shortNameOfWeather: main, descriptionOfWeather: description))
                
            }
            
            DispatchQueue.main.async  {
                for value in self.arrayCurrentWeather {
                    self.shortNameOfWeatherLabel.text = value.shortNameOfWeather
                    self.descriptionOfWeatherLabel.text = value.descriptionOfWeather
                    if value.weatherID == 800 {
                        self.WeatherImageView.image = UIImage(named: "diego-ph-5LOhydOtTKU-unsplash")
                        self.WeatherImageView.contentMode = .scaleAspectFill
                    }
                }
            }
            print(self.arrayCurrentWeather)
            
        }
        
        session.resume()
        
    }

}

