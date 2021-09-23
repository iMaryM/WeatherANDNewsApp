//
//  MainViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 22.09.21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var addCityTextField: UITextField!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    var currentWeatherMain: CurrentWeatherMain?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardNotification()
        
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        constraint.constant = keyboardFrameSize.height
    }
    
    @objc
    func keyboardWillHide() {
        constraint.constant = 160
    }

    @IBAction func goToWeatherAction(_ sender: UIButton) {
        
        addCityTextField.resignFirstResponder()
        
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
