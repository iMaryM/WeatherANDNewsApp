//
//  ParseManager.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 23.09.21.
//

import UIKit

class ParseManager {
    static let shared = ParseManager()
    
    func parseCurrentWeather(from data: Data) -> CurrentWeatherMain? {
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {return nil}
        
        guard let weatherDescription = json["weather"] as? [[String: Any]] else {return nil}
        
        var arrayOfCurrentWeatherDescription: [CurrentWeatherDescription] = []
        
        for value in weatherDescription {
            guard let main = value["main"] as? String,
                  let description = value["description"] as? String,
                  let id = value["id"] as? Int,
                  let imageName = value["icon"] as? String else {return nil}
            
            arrayOfCurrentWeatherDescription.append(CurrentWeatherDescription(weatherID: id, shortNameOfWeather: main, descriptionOfWeather: description, imageName: imageName))
        }
        
        guard let weatherMain = json["main"] as? [String: Any] else {return nil}
        
        guard let currentTemperature = weatherMain["temp"] as? Double,
              let feelsTemperature = weatherMain["feels_like"] as? Double,
              let atmosphericPressure = weatherMain["pressure"] as? Int,
              let humidity = weatherMain["humidity"] as? Int,
              let maxTemperature = weatherMain["temp_max"] as? Double,
              let minTemperature = weatherMain["temp_min"] as? Double else {return nil}
        
        guard let sys = json["sys"] as? [String: Any] else {return nil}
        
        guard let sunrise = sys["sunrise"] as? Int,
              let sunset = sys["sunset"] as? Int else {return nil}
        
        guard let wind = json["wind"] as? [String: Any] else {return nil}
        
        guard let windSpeed = wind["speed"] as? Double,
              let windDirection = wind["deg"] as? Int else {return nil}
        
        return CurrentWeatherMain(arrayOfCurrentWeatherDescription: arrayOfCurrentWeatherDescription, currentTemperature: currentTemperature, feelsTemperature: feelsTemperature, atmosphericPressure: atmosphericPressure, humidity: humidity, maxTemperature: maxTemperature, minTemperature: minTemperature, sunrise: Date(timeIntervalSince1970: TimeInterval(sunrise)), sunset: Date(timeIntervalSince1970: TimeInterval(sunset)), windSpeed: windSpeed, windDirection: windDirection)
    }
    
    func parseNews(from data: Data) -> [NewsArticle] {
        
        var news: [NewsArticle] = []
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {return []}
        
        guard let results = json["results"] as? [[String: Any]] else {return []}
        
        results.forEach { result in
            guard let section = result["section"] as? String,
                  let subsection = result["subsection"] as? String,
                  let title = result["title"] as? String,
                  let abstract = result["abstract"] as? String,
                  let url = result["url"] as? String,
                  let publishedDate = result["published_date"] as? String,
                  let multimedias = result["multimedia"] as? [[String : Any]] else {
                      return
                  }
            
            var images: [Data] = []
            
            multimedias.forEach { multimedia in
                guard let imageData = multimedia["url"] as? String else {return}
                guard let url = URL(string: imageData),
                      let data = try? Data(contentsOf: url) else {return}
                images.append(data)
            }
            
            var newsSection = ""
            if subsection == "" {
                newsSection = section.prefix(1).uppercased() + section.lowercased().dropFirst()
            } else {
                newsSection = "\(section.prefix(1).uppercased() + section.lowercased().dropFirst()): \(subsection.lowercased())"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: publishedDate)!
            
            news.append(NewsArticle(section: newsSection, title: title, abstract: abstract, publishDate: date, url: url, imageData: images))
            
            
        }
        
        return news
        
    }
}
