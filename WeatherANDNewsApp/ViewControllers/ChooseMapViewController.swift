//
//  ChooseMapViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 16.10.21.
//

import UIKit
import AVKit
import GoogleMaps
import MapKit
import NVActivityIndicatorView
import GSMessages
import CoreLocation

class ChooseMapViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    var appleMapView: MKMapView?
    var googleMapView: GMSMapView?
    
    var currentWeatherMain: CurrentWeatherMain?
    var addedCity: String?
    var dispatchItem: DispatchWorkItem?
    
    var locationManager = CLLocationManager()
    var marker: GMSMarker?
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RemoteConfigManager.shared.connectToFireBaseRC()
        
        locationButton.isUserInteractionEnabled = false

        switch RemoteConfigManager.shared.getStringValue(from: .kindOfMaps) {
        case "Apple":
            appleMapView = MKMapView(frame: mapView.bounds)
            mapView.addSubview(appleMapView!)
            appleMapView?.showsUserLocation = true
            
            setupLocation { isAccess in
                
                guard isAccess else {
                    appleMapView?.centerCoordinate = CLLocationCoordinate2D(latitude: 50.4546600, longitude: 30.5238000)
                    annotation.coordinate = appleMapView!.centerCoordinate
                    appleMapView?.addAnnotation(annotation)
                    return
                }
                
            }
            
            appleMapView?.delegate = self
            
        case "Google":
            googleMapView = GMSMapView(frame: mapView.bounds)
            mapView.addSubview(googleMapView!)
            googleMapView?.isMyLocationEnabled = true
            
            setupLocation { isAccess in
                
                guard isAccess else {
                    googleMapView?.camera = GMSCameraPosition(latitude: 50.4546600, longitude: 30.5238000, zoom: 10.0)
                    marker = GMSMarker(position: CLLocationCoordinate2D(latitude: 50.4546600, longitude: 30.5238000))
                    setIconToMapMarker()
                    marker?.map = googleMapView
                    return
                }
                
            }
            
            googleMapView?.delegate = self
            
        default: break
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setVideoOnMainScreen()
  
    }
    
    func setIconToMapMarker() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .red
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        marker?.iconView = imageView
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
    
//    геопозиция
    func setupLocation(_ completion: (Bool) -> ()) {
        //проверка можно ли исп геолокацию
        guard CLLocationManager.locationServicesEnabled() else {
            completion(false)
            return
        }
        
        //указываем точность геопозиции
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
    
    @IBAction func locationButtonDidTap(_ sender: UIButton) {

        GSMessage.errorBackgroundColor = UIColor(red: 219.0/255, green: 36.0/255,  blue: 27.0/255,  alpha: 0.35)
        GSMessage.warningBackgroundColor = UIColor(red: 230.0/255, green: 189.0/255, blue: 1.0/255,   alpha: 0.55)
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballSpinFadeLoader, color: .lightGray, padding: nil)
        
        guard let addedCity = addedCity,
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

extension ChooseMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locationManager.location?.coordinate

        switch RemoteConfigManager.shared.getStringValue(from: .kindOfMaps) {
        case "Apple":
            if location != nil  {
                appleMapView?.centerCoordinate = location!
                annotation.coordinate = appleMapView!.centerCoordinate
                appleMapView?.addAnnotation(annotation)
            }
            self.locationManager.stopUpdatingLocation()
        case "Google":
            if location != nil {
                googleMapView?.camera = GMSCameraPosition.camera(withTarget: location!, zoom: 10)
                
                marker = GMSMarker(position: location!)
                setIconToMapMarker()
                marker?.map = googleMapView
            }
            self.locationManager.stopUpdatingLocation()
            marker?.map = nil
        default:
            break
        }
    }
    
}

extension ChooseMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        marker?.map = nil
        
        marker = GMSMarker(position: position.target)
        setIconToMapMarker()
        marker?.map = mapView
        
        self.locationButton.setTitle("Founded...", for: .normal)
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //отмена выполнения блока кода
        self.dispatchItem?.cancel()
        
        //создание блока кода
        self.dispatchItem = DispatchWorkItem {
            guard self.dispatchItem?.isCancelled == false else {return}
            let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
            CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en")) { placeMark, error in
                if let _ = error {
                    self.locationButton.setTitle("Not found location", for: .normal)
                } else {
                    guard let place = placeMark?.first else { return }
                    
                    let street = "\(place.country ?? ""), \(place.locality ?? "")"
                    self.addedCity = place.locality
                    self.locationButton.setTitle(street, for: .normal)
                    self.locationButton.isUserInteractionEnabled = true
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: self.dispatchItem!)
    }

}

extension ChooseMapViewController: MKMapViewDelegate {

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        annotation.coordinate = mapView.centerCoordinate
        
        self.locationButton.setTitle("Founded...", for: .normal)
        
        //отмена выполнения блока кода
        self.dispatchItem?.cancel()
        
        //создание блока кода
        self.dispatchItem = DispatchWorkItem {
            guard self.dispatchItem?.isCancelled == false else {return}
            let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en")) { placeMark, error in
                if let _ = error {
                    self.locationButton.setTitle("Not found location", for: .normal)
                } else {
                    guard let place = placeMark?.first else { return }
                    let street = "\(place.country ?? ""), \(place.locality ?? "")"
                    self.addedCity = place.locality
                    self.locationButton.setTitle(street, for: .normal)
                    self.locationButton.isUserInteractionEnabled = true
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: self.dispatchItem!)

    }
    
}




