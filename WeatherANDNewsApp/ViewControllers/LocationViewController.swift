//
//  LocationViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 18.09.21.
//

import UIKit
import NVActivityIndicatorView
import GSMessages

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
        
        GSMessage.errorBackgroundColor = UIColor(red: 219.0/255, green: 36.0/255,  blue: 27.0/255,  alpha: 0.35)
        GSMessage.warningBackgroundColor = UIColor(red: 230.0/255, green: 189.0/255, blue: 1.0/255,   alpha: 0.55)
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballSpinFadeLoader, color: .lightGray , padding: nil)
        
        guard let addedLocation = addLocationTextField.text ,
              addedLocation != "" else {
            self.showMessage("Enter the city, please", type: .warning, options: [
                                .animationDuration(0.3),
                                .position(.bottom),
                                .textColor(.lightGray)])
            return
        }
        
        HTTPManager.shared.getCurrentWeather(for: addedLocation) { weather in
            self.currentWeatherMain = weather
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            guard self.currentWeatherMain != nil else {
                self.showMessage("\(addedLocation) not found\n Enter the correct city, please", type: .error, options: [
                                    .animationDuration(0.4),
                                    .position(.bottom),
                                    .textColor(.lightGray),
                                    .textNumberOfLines(0)])
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
