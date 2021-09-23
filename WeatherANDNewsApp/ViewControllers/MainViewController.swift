//
//  MainViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 22.09.21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var addCityTextField: UITextField!
    
    var currentWeatherMain: CurrentWeatherMain?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func goToWeatherAction(_ sender: UIButton) {
        guard let addedCity = addCityTextField.text else {
            return
        }
        
        HTTPManager.shared.getCurrentWeather(for: addedCity) { weather in
            self.currentWeatherMain = weather
            guard self.currentWeatherMain != nil else {
                let alert = UIAlertController(title: "Not Found", message: "\(addedCity) does not exist", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelButton)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let weatherViewController = self.getViewController(from: "Weather", and: "WeatherViewController") as? WeatherViewController else {return}
            weatherViewController.addedCity = addedCity
            weatherViewController.currentWeatherMain = self.currentWeatherMain
            weatherViewController.modalPresentationStyle = .fullScreen
            weatherViewController.modalTransitionStyle = .coverVertical
            self.present(weatherViewController, animated: true, completion: nil)
            
        }

    }
    
}
