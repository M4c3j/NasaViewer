//
//  ViewController.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-03-20.
//

import UIKit

let API_KEY = "sxne1jfOjfyTbNtSTLORHh96OWyAZg73X8XFvVt7"
let API_KEY_2 = "WZLcvI2hX6U5Nb5lu3dkS73hfkYxjjCpLxzoydxU"

class MainViewController: UIViewController, NasaServiceGetRandomDidFinishDownloading {
        
    let tableView = UITableView()
    var data: [PictureOfTheDay] = []
    let nasaData = NasaService()
    var selectedRow: IndexPath?
    var rowsPosition: [IndexPath]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        nasaData.delegate = self
        nasaData.getRandom(quantity: 50)
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
