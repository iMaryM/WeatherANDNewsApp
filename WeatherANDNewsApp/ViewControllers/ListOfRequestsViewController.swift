//
//  ListOfRequestsViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 19.10.21.
//

import UIKit

class ListOfRequestsViewController: UIViewController {

    @IBOutlet weak var requestsTableView: UITableView!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    
    var currentWeatherMain: CurrentWeatherMain?
    var requests: [RequestInfoDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requests = RealmManager.shared.getRequestInfo()

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
        
        setupTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupTable() {
        requestsTableView.dataSource = self
        requestsTableView.delegate = self
        requestsTableView.tableFooterView = UIView()
        requestsTableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "RequestTableViewCell")
    }

    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearAllButton(_ sender: UIButton) {
        RealmManager.shared.deleteAll()
        requests.removeAll()
        requestsTableView.reloadData()
    }
    
}

extension ListOfRequestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTableViewCell", for: indexPath) as? RequestTableViewCell else {
            return UITableViewCell()
        }
        
        
        cell.setupCell(request: requests[indexPath.row])
        return cell
    }
    
}

extension ListOfRequestsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
