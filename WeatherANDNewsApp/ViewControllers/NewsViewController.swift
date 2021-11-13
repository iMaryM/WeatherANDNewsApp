//
//  NewsViewController.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 12.11.21.
//

import UIKit
import NVActivityIndicatorView

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    var news: [NewsArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballSpinFadeLoader, color: .lightGray, padding: nil)
        
        HTTPManager.shared.getNews { newsArticle in
            self.news = newsArticle
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            self.setupTable()
        }
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    private func setupTable() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView()
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }

}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? WebViewController else {return}
        vc.modalPresentationStyle = .pageSheet
        vc.modalTransitionStyle = .coverVertical
        vc.url = news[indexPath.row].url
        present(vc, animated: true, completion: nil)
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell else {return UITableViewCell()}
        
        cell.setupCell(news: news[indexPath.row])
        return cell
    }
}
