//
//  LocationViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 18.09.21.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var addedLocationTableView: UITableView!
    @IBOutlet weak var addLocationTextField: UITextField!
    
    var arrayCurrentWeather: [CurrentWeatherDescription] = []
    
    var location: Location = Location(cityName: "Minsk")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for value in self.arrayCurrentWeather {
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
        let mainViewController = getViewController(from: "Main", and: "MainController")
        mainViewController.modalPresentationStyle = .fullScreen
        mainViewController.modalTransitionStyle = .flipHorizontal
        present(mainViewController, animated: true, completion: nil)
    }
    
    // по кнопке надо вызвать метод с названием города
    // если 200 код - все ок
    // если 500 - сообщение что неправильно введн город
    @IBAction func addLocation(_ sender: Any) {
        guard let addedLocation = addLocationTextField.text else {
            return
        }
        
        let URLString = "https://api.openweathermap.org/data/2.5/weather?q=\(addedLocation)&appid=5191046f25842380a185c9d77f29dc49"
        
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
                    self.location.cityName = addedLocation
                    self.addedLocationTableView.reloadData()
                }
            }
        }
        
        session.resume()
    }
    
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell") as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(location: location)
        return cell
    }
}
