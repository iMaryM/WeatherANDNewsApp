//
//  LocationViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 18.09.21.
//

import UIKit
import NVActivityIndicatorView

class LocationViewController: UIViewController {

    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var addedLocationTableView: UITableView!
    @IBOutlet weak var addLocationTextField: UITextField!
    
    var currentWeatherMain: CurrentWeatherMain?
    
    var addedCity = ""
    
    var completion: ((String, CurrentWeatherMain?) -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentWeather = currentWeatherMain else {return}
        
        for value in currentWeather.arrayOfCurrentWeatherDescription {
            if value.weatherID == 800 {
                self.currentWeatherImageView.image = UIImage(named: "diego-ph-5LOhydOtTKU-unsplash")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            }
            
            if value.weatherID == 804 {
                self.currentWeatherImageView.image = UIImage(named: "clouds")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            }
            
            if value.weatherID == 500 {
                self.currentWeatherImageView.image = UIImage(named: "rain")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            }
            
        }
        
        addedLocationTableView.dataSource = self
        addedLocationTableView.delegate = self
        
        addedLocationTableView.tableFooterView = UIView()
        addedLocationTableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
    }
    
    @IBAction func goToWeatherController(_ sender: UIButton) {
        completion?(addedCity, currentWeatherMain)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballSpinFadeLoader, color: .lightGray , padding: nil)
        
        guard let addedLocation = addLocationTextField.text else {
            return
        }
        
        HTTPManager.shared.getCurrentWeather(for: addedLocation) { weather in
            self.currentWeatherMain = weather
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            guard self.currentWeatherMain != nil else {
                let alert = UIAlertController(title: "Not Found", message: "\(addedLocation) does not exist", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelButton)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.addedCity = addedLocation
            self.addedLocationTableView.reloadData()
        }
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentWeather = currentWeatherMain else {
            return 0
        }
        return currentWeather.arrayOfCurrentWeatherDescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell") as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(location: addedCity, currentWeather: currentWeatherMain)
        return cell
    }
}
