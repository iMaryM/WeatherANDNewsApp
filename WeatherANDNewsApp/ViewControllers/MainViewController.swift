//
//  MainViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 22.09.21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var addCityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func goToWeatherAction(_ sender: UIButton) {
        guard let addedCity = addCityTextField.text else {
            return
        }
        
        let URLString = "https://api.openweathermap.org/data/2.5/weather?q=\(addedCity)&appid=5191046f25842380a185c9d77f29dc49"
        
        guard let url = URL(string: URLString) else {return}
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                guard statusCode == 200 else {
                    DispatchQueue.main.async  {
                        let alert = UIAlertController(title: "Not Found", message: "\(statusCode)", preferredStyle: .alert)
                        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alert.addAction(cancelButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                
                DispatchQueue.main.async  {
                    guard let weatherViewController = self.getViewController(from: "Weather", and: "WeatherViewController") as? WeatherViewController else {return}
                    weatherViewController.addedCity = addedCity
                    weatherViewController.modalPresentationStyle = .fullScreen
                    weatherViewController.modalTransitionStyle = .coverVertical
                    self.present(weatherViewController, animated: true, completion: nil)
                }
            }
        }
        
        session.resume()
    }
    
}
