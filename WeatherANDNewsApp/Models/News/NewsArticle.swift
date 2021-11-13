//
//  NewsArticle.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 13.11.21.
//

import UIKit

class NewsArticle {
    var section: String
    var title: String
    var abstract: String
    var publishDate: Date
    var url: String
    var imageData: [Data]
    
    init(section: String, title: String, abstract: String, publishDate: Date, url: String, imageData: [Data]) {
        self.section = section
        self.title = title
        self.abstract = abstract
        self.publishDate = publishDate
        self.url = url
        self.imageData = imageData
    }
}
