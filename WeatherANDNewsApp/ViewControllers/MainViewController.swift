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

class MainViewController: UIViewController {

    @IBOutlet weak var addCityTextField: UITextField!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    
    var currentWeatherMain: CurrentWeatherMain?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardNotification()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setVideoOnMainScreen()
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
            guard self.currentWeatherMain != nil else {
                self.showMessage("\(addedCity) not found\n Enter the correct city, please", type: .error, options: [
                                    .animationDuration(0.3),
                                    .textColor(.lightGray),
                                    .textNumberOfLines(0)])
                return
            }
            
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
