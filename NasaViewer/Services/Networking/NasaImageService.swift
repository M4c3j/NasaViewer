import UIKit

class NasaImageService {
    
    weak var delegate: NasaImageServiceDelegate? = nil
    var image: UIImage = UIImage()
    
    ///downloads image from given url, if url has youtube link inside then it will get thumbnail of the video.
//    func downloadImage(from url: String) {
//        var imageURL = url
//        if url.contains("youtube") {
//            guard let videoID = url.youtubeID else {
//                print("Failed to unwrapp videoID inside downloadImage \(self)")
//                return
//            }
//            imageURL = "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg"
//        }
//        if url.contains("vimeo") {
//            guard let videoID = url.vimeoID else {
//                print("Failed to unwrapp videoID inside downloadImage \(self)")
//                return
//            }
//            imageURL = "https://vumbnail.com/\(videoID).jpg"
//        }
//        guard let url = URL(string: imageURL) else {
//            print("Bad image URL \"\(url)\"")
//            return
//        }
//        NasaService.downloadData(fromUrl: url) { downloadedData in
//            if let data = downloadedData {
//                guard let decodedImage = UIImage(data: data) else {
//                    self.image = UIImage(systemName: "x.square.fill")!
//                    return
//                }
//                DispatchQueue.main.async { [weak self] in
//                    self?.image = decodedImage
//                    self?.delegate?.imageDidDownloaded()
//                }
//            } else {
//                print("No data returned")
//            }
//        }
//    }
    
    func downloadImage(from url: String) throws {
        var imageURL = url
        if url.contains("youtube") {
            guard let videoID = url.youtubeID else {
                throw ImageDownloadError.badURL
            }
            imageURL = "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg"
        }
        if url.contains("vimeo") {
            guard let videoID = url.vimeoID else {
                throw ImageDownloadError.badURL
            }
            imageURL = "https://vumbnail.com/\(videoID).jpg"
        }
        guard let url = URL(string: imageURL) else {
            throw ImageDownloadError.badURL
        }
        
        do {
            let imageData = try NasaService.downloadData(fromUrl: url)
            guard let decodedImage = UIImage(data: imageData) else {
                throw ImageDownloadError.imageDecodingError
            }
            DispatchQueue.main.async { [weak self] in
                self?.image = decodedImage
                self?.delegate?.imageDidDownloaded()
            }
        } catch let error {
            switch error {
            case NasaServiceError.noDataReturned:
                throw ImageDownloadError.noDataReturned
            default:
                throw error
            }
        }
    }
}

protocol NasaImageServiceDelegate: AnyObject {
    
    func imageDidDownloaded()
    
}

enum ImageDownloadError: Error {
    case badURL
    case noDataReturned
    case imageDecodingError
}
