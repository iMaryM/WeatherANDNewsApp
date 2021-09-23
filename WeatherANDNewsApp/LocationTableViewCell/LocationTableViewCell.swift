//
//  LocationTableViewCell.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 19.09.21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(location: String, currentWeather: CurrentWeatherMain?) {
        guard let currentWeather = currentWeather,
              let currentWeatherDescription = currentWeather.arrayOfCurrentWeatherDescription.first else {
            return
        }
        weatherImageView.image = UIImage(named: "\(currentWeatherDescription.imageName).png")
        weatherImageView.contentMode = .scaleAspectFill
        currentTemperatureLabel.text = (currentWeather.currentTemperature - 273.15) > 0 ? "+\(Int((currentWeather.currentTemperature - 273.15)))°C" : "\(Int((currentWeather.currentTemperature - 273.15)))°C"
        cityNameLabel.text = location
        currentWeatherDescriptionLabel.text = currentWeatherDescription.descriptionOfWeather
        
    }
}
