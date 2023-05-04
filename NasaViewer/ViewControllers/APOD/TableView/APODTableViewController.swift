//
//  ViewController.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-03-20.
//

import UIKit



class APODTableViewController: UIViewController, NasaServiceGetRandomDidFinishDownloading {
        
    let tableView = UITableView()
    var data: [PictureOfTheDay] = []
    let nasaData = NasaService()
    var selectedRow: IndexPath?
    var rowsPosition: [IndexPath]?
    
    init(articlesFromSelectedMonth: Date) throws {
        try nasaData.getFrom(month: articlesFromSelectedMonth)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(articleFromDate: Date) throws {
        try nasaData.getFrom(day: articleFromDate)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(randomArticles: Int) throws {
        try nasaData.getRandom(quantity: randomArticles)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        nasaData.delegate = self
        configureNavController()
    }
    
    func articlesDataDidDownloaded() {
        DispatchQueue.main.async {
            self.data = self.nasaData.articles
            self.tableView.reloadData()
        }
    }
    
    func configureNavController() {
        guard let navC = navigationController else {
            print("failed to unwrap navigationController in configureNavController")
            return
        }
        navC.title = "Nasa"
        navC.isNavigationBarHidden = false
        navC.hidesBarsWhenVerticallyCompact = true
        navC.navigationBar.barStyle = .black
        navC.navigationBar.isTranslucent = false
        navC.navigationBar.barStyle = UIBarStyle.black
    }
    
}
