//
//  LocationTableViewCell.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 19.09.21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(location: Location) {
        cityNameLabel.text = location.cityName
    }
}
