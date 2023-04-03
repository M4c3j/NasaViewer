//
//  BigImageCell.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-03-29.
//

import UIKit
import SwiftUI

class BigImageCell: UITableViewCell, NasaImageServiceDelegate {

    static var identifier = "BigImageCell"
    let imageService = NasaImageService()
    var data: PictureOfTheDay? = nil
    var hostingController: UIHostingController<BigImageCell_SwiftUI>?
    let swiftUIView = BigImageCell_SwiftUI(image: UIImage(systemName: "arrow.clockwise"), title: "", description: "", date: "", copyright: "")
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageService.delegate = self
        configureHostingController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(data: PictureOfTheDay) {
        guard let url = data.url else {
            print("Failed to get url from data.url in configureCell")
            return
        }
        imageService.downloadImage(from: url)
        hostingController?.rootView.image = nil
        hostingController?.rootView.title = data.title ?? "Title"
        hostingController?.rootView.description = data.explanation ?? "Description"
        if let date = data.date {
            hostingController?.rootView.date = readDate(from: date)
        }
        let authors = data.copyright ?? ""
        if !authors.isEmpty {
            hostingController?.rootView.copyright = "©\(authors)"
        }
        self.reloadInputViews()
    }
    
    private func configureHostingController() {
        let hostingController = UIHostingController(rootView: swiftUIView)
        self.hostingController = hostingController
        contentView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func readDate(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateToFormat = dateFormatter.date(from: date) {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = newFormatter.string(from: dateToFormat)
            return formattedDate
        } else {
            return data?.date ?? "Failed to read date"
        }
    }
    
    func imageDidDownloaded() {
        hostingController?.rootView.image = imageService.image
        self.reloadInputViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
