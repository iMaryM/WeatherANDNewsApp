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
            switch value.weatherID {
            case 200, 201, 202, 210, 211, 212, 221, 230, 231, 232:
                self.currentWeatherImageView.image = UIImage(named: "thunderstorm_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 300...302, 310...314, 321:
                self.currentWeatherImageView.image = UIImage(named: "drizzle_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 500...504, 511, 520...522, 531:
                self.currentWeatherImageView.image = UIImage(named: "rain_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 600...602, 611...616, 620...622:
                self.currentWeatherImageView.image = UIImage(named: "snow_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 701:
                self.currentWeatherImageView.image = UIImage(named: "mist_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 711:
                self.currentWeatherImageView.image = UIImage(named: "smoke_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 721:
                self.currentWeatherImageView.image = UIImage(named: "haze_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 731, 761:
                self.currentWeatherImageView.image = UIImage(named: "dust_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 741:
                self.currentWeatherImageView.image = UIImage(named: "fog_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 751:
                self.currentWeatherImageView.image = UIImage(named: "sand_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 762:
                self.currentWeatherImageView.image = UIImage(named: "ash_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 771:
                self.currentWeatherImageView.image = UIImage(named: "squall_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 781:
                self.currentWeatherImageView.image = UIImage(named: "tornado_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 800:
                self.currentWeatherImageView.image = UIImage(named: "clear_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            case 801...804:
                self.currentWeatherImageView.image = UIImage(named: "сlouds_day")
                self.currentWeatherImageView.contentMode = .scaleAspectFill
            default: break
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
