//
//  NewsTableViewCell.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 12.11.21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(news: NewsArticle) {
        
        if let image = news.imageData.first {
            imageNews.image = UIImage(data: image)
        } else {
            imageNews.image = UIImage(named: "NYTimes_Logo")
        }
        
        sectionLabel.text = news.section
        titleLabel.text = news.title
        abstractLabel.text = news.abstract
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.M.yyyy HH:mm"
        
        dateLabel.text = dateFormatter.string(from: news.publishDate)
        
    }
    
}
