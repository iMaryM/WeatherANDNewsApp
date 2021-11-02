//
//  MainViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 22.09.21.
//

import UIKit
import NVActivityIndicatorView
import GSMessages
import AVFoundation
import CoreLocation

class MainViewController: UIViewController {

    @IBOutlet weak var addCityTextField: UITextField!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    
    var currentWeatherMain: CurrentWeatherMain?
    var locationManager = CLLocationManager()
    var addedCity: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardNotification()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setVideoOnMainScreen()
        initializeTheLocationManager()
        
        guard let nextVC = SettingsManager.shared.currentVC else {
            return
        }
        
        setupLocation { isAccess in
            guard isAccess else {
                let alert = UIAlertController(title: "Attention!", message: "Your location is unavaliable. Give access to use you location in Settings, please.", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let settingsButton = UIAlertAction(title: "Settings", style: .default) { _ in
                    guard let url = URL(string: UIApplication.openSettingsURLString) else {return}
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                }
                alert.addAction(cancelButton)
                alert.addAction(settingsButton)
                present(alert, animated: true, completion: nil)
                return
            }
        }

    }
    
    func initializeTheLocationManager() {
        //указываем точность геопозиции
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //    геопозиция
    func setupLocation(_ completion: (Bool) -> ()) {
        //проверка можно ли исп геолокацию
        guard CLLocationManager.locationServicesEnabled() else {
            completion(false)
            return
        }
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
    
    
    deinit {
        removeKeyboardNotification()
        NotificationCenter.default.removeObserver(self)
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

    func setVideoOnMainScreen() {
        guard let urlString = Bundle.main.path(forResource: "Fog", ofType: "mp4") else { return }
        let url = URL(fileURLWithPath: urlString)
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(origin: .zero, size: videoView.frame.size)
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        registerForVideoNotification(playerItem: playerItem, player: player)
        player.play()
    }
    
    func registerForVideoNotification(playerItem: AVPlayerItem, player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main, using: { _ in
            player.seek(to: .zero)
            player.play()
        })
    }
    
    @IBAction func goToWeatherAction(_ sender: UIButton) {
        
        GSMessage.errorBackgroundColor = UIColor(red: 219.0/255, green: 36.0/255,  blue: 27.0/255,  alpha: 0.35)
        GSMessage.warningBackgroundColor = UIColor(red: 230.0/255, green: 189.0/255, blue: 1.0/255,   alpha: 0.55)
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballSpinFadeLoader, color: .lightGray, padding: nil)
        
        addCityTextField.resignFirstResponder()
        
        guard let addedCity = addCityTextField.text,
              addedCity != "" else {
            self.showMessage("Enter the city, please", type: .warning, options: [
                                .animationDuration(0.3),
                                .textColor(.lightGray)])
            return
        }
        
        HTTPManager.shared.getCurrentWeather(for: addedCity) { weather in
            self.currentWeatherMain = weather
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            guard let currentWeatherMain_ = self.currentWeatherMain else {
                self.showMessage("\(addedCity) not found\n Enter the correct city, please", type: .error, options: [
                                    .animationDuration(0.3),
                                    .textColor(.lightGray),
                                    .textNumberOfLines(0)])
                return
            }
            
            guard let currentWeatherMainF = currentWeatherMain_.arrayOfCurrentWeatherDescription.first else { return }

            let weatherInfoDB = WeatherInfoDB(shortNameOfWeather: currentWeatherMainF.shortNameOfWeather, descriptionOfWeather: currentWeatherMainF.descriptionOfWeather, imageName: currentWeatherMainF.imageName, currentTemperature: currentWeatherMain_.currentTemperature)
            let requestInfoDB = RequestInfoDB(date: Date(), city: addedCity, currentWeather: weatherInfoDB)
            RealmManager.shared.saveRequestInfo(by: requestInfoDB)
            
            
            guard let weatherViewController = self.getViewController(from: "Weather", and: "WeatherViewController") as? WeatherViewController else {return}
            weatherViewController.addedCity = addedCity
            weatherViewController.currentWeatherMain = self.currentWeatherMain
            weatherViewController.modalPresentationStyle = .fullScreen
            weatherViewController.modalTransitionStyle = .coverVertical
            self.present(weatherViewController, animated: true, completion: nil)
            
        }
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
}

extension MainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let nextVC = SettingsManager.shared.currentVC else {
            return
        }
            
            if let location = locations.last {
                
                CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en")) { placeMark, error in
                    if let error = error {
                        print(error.localizedDescription ?? "Error")
                    } else {
                        guard let place = placeMark?.first else { return }
                        self.addedCity = place.locality
                        
                        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballSpinFadeLoader, color: .lightGray, padding: nil)
                        
                        if let addedCity = self.addedCity {
                            HTTPManager.shared.getCurrentWeather(for: addedCity) { weather in
                                
                                self.currentWeatherMain = weather
                                activityIndicator.stopAnimating()
                                activityIndicator.isHidden = true
                                guard let _ = self.currentWeatherMain else {
                                    self.showMessage("1 \(addedCity) not found\n Enter the correct city, please", type: .error, options: [
                                        .animationDuration(0.3),
                                        .textColor(.lightGray),
                                        .textNumberOfLines(0)])
                                    return
                                }
                                
                                guard let weatherViewController = self.getViewController(from: "Weather", and: nextVC) as? WeatherViewController else {return}
                                weatherViewController.addedCity = addedCity
                                weatherViewController.currentWeatherMain = self.currentWeatherMain
                                weatherViewController.modalPresentationStyle = .fullScreen
                                weatherViewController.modalTransitionStyle = .coverVertical
                                self.present(weatherViewController, animated: true, completion: nil)
                                
                            }
                            activityIndicator.center = self.view.center
                            self.view.addSubview(activityIndicator)
                            activityIndicator.startAnimating()
                        } else {
                            self.showMessage("Enter the city, please", type: .warning, options: [
                                .animationDuration(0.3),
                                .textColor(.lightGray),
                                .textNumberOfLines(0)])
                        }
                    }
                }
            }
        
        locationManager.stopUpdatingLocation()
        
    }
    
}
