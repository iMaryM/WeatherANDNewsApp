//
//  RequestTableViewCell.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 19.10.21.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconWeatherImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var shortNameWeatherLabel: UILabel!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var currentTemperatureLebel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(request: RequestInfoDB) {
        
        guard let currentWeather = request.currentWeather else {return}
        dateLabel.text = request.date.getCurrentDate(from: "dd.MM.yy HH:mm", locale: .current, timeZone: .current)
        iconWeatherImageView.image = UIImage(named: currentWeather.imageName)
        cityLabel.text = request.city
        shortNameWeatherLabel.text = currentWeather.shortNameOfWeather
        descriptionWeatherLabel.text = currentWeather.descriptionOfWeather
        
        let currentTemperature = currentWeather.currentTemperature - 273.15
        currentTemperatureLebel.text =  currentTemperature > 0 ? "+\(Int(currentTemperature))°C" : "\(Int(currentTemperature))°C"
    }
    
}
