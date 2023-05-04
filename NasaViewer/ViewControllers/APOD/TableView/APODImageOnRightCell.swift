//
//  CommonCellTableViewCell.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-03-22.
//

//TODO: TODO
/*
 2. Download image after loading page

*/
import UIKit

class APODImageOnRightCell: UITableViewCell, NasaImageServiceDelegate {

    let imageService = NasaImageService()
    var data: PictureOfTheDay? = nil
    
    static let identifier = "ImageOnRightCell"
    
    let spacingImageText: CGFloat = 5
    let image = UIImageView()
    let title = UILabel()
    let descriptionText = UILabel()
    let date = UILabel()
    let clockSF = UIImageView()
    let copyright = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageService.delegate = self
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always use init(style: , reuseIdentifier:  when initializing CommonCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    func imageDidDownloaded() {
        DispatchQueue.main.async { [weak self] in
            self?.image.image = self?.imageService.image
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
        }
        contentView.reloadInputViews()
    }
    
    public func configureCell(data: PictureOfTheDay) {
        guard let url = data.url else {
            print("Failed to get url from data.url in configureCell \(self)")
            return
        }
        do
        {
            try imageService.downloadImage(from: url)
        }
        catch {
            self.image.image = UIImage(named: "x.circle.fill")
        }
        title.text = data.title
        descriptionText.text = data.explanation
        if let date = data.date {
            readDate(from: date)
        }
        let authors = data.copyright ?? ""
        if !authors.isEmpty {
            copyright.text = "©\(authors)"
        }
        self.reloadInputViews()
    }
    
    private func createUI() {
        createImage()
        createTitle()
        createDescription()
        createClockSF()
        createDateLayout()
        readDate(from: data?.date ?? "")
        createCopyright()
    }
    
    private func createImage() {
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.heightAnchor.constraint(equalToConstant: 100)
        ])
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
        activityIndicator.startAnimating()
    }
    
    private func createTitle() {
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = data?.title ?? "Title"
        title.font = .preferredFont(forTextStyle: .headline)
        title.adjustsFontSizeToFitWidth = false
        title.textAlignment = .left
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -spacingImageText),
            title.topAnchor.constraint(equalTo: image.topAnchor)
        ])
    }
    
    private func createDescription() {
        contentView.addSubview(descriptionText)
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.text = data?.explanation ?? "Description"
        descriptionText.textAlignment = .justified
        descriptionText.font = .preferredFont(forTextStyle: .caption1)
        descriptionText.numberOfLines = 4
        descriptionText.clipsToBounds = true
        NSLayoutConstraint.activate([
            descriptionText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -spacingImageText),
            descriptionText.topAnchor.constraint(equalTo: title.bottomAnchor)
        ])
    }
    
    private func createClockSF(){
        contentView.addSubview(clockSF)
        clockSF.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIImage.SymbolConfiguration(paletteColors: [.secondaryLabel])
        configuration = configuration.applying(UIImage.SymbolConfiguration(textStyle: .caption2))
        let symbol = UIImage(systemName: "clock", withConfiguration: configuration)!
        clockSF.contentMode = .scaleAspectFill
        clockSF.image = symbol
        NSLayoutConstraint.activate([
            clockSF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clockSF.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: spacingImageText),
            clockSF.widthAnchor.constraint(equalToConstant: 14),
            clockSF.bottomAnchor.constraint(equalTo: image.bottomAnchor)
        ])
    }
    
    private func readDate(from date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateToFormat = dateFormatter.date(from: date) {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = newFormatter.string(from: dateToFormat)
            self.date.text = formattedDate
        } else {
            self.date.text = data?.date
        }
    }
    
    private func createDateLayout() {
        contentView.addSubview(date)
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = .preferredFont(forTextStyle: .caption2)
        NSLayoutConstraint.activate([
            date.leadingAnchor.constraint(equalTo: clockSF.trailingAnchor, constant: spacingImageText),
            date.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            date.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: spacingImageText),
            date.bottomAnchor.constraint(equalTo: image.bottomAnchor)
        ])
    }
    
    private func createCopyright() {
        contentView.addSubview(copyright)
        copyright.translatesAutoresizingMaskIntoConstraints = false
        copyright.adjustsFontSizeToFitWidth = false
        copyright.font = .preferredFont(forTextStyle: .caption2)
        copyright.textAlignment = .right
        copyright.numberOfLines = 1
        NSLayoutConstraint.activate([
            copyright.leadingAnchor.constraint(equalTo: date.trailingAnchor),
            copyright.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -spacingImageText),
            copyright.topAnchor.constraint(equalTo: date.topAnchor),
            copyright.bottomAnchor.constraint(equalTo: image.bottomAnchor)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

#if DEBUG
import SwiftUI
struct ImageOnRightCell_Preview: PreviewProvider {
    static var previews: some View = Preview(for: APODImageOnRightCell())
}
#endif
