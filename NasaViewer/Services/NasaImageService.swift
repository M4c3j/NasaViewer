import UIKit

class NasaImageService {
    
    weak var delegate: NasaImageServiceDelegate? = nil
    var image: UIImage = UIImage()
    
    func downloadImage(from url: String) {
        guard let url = URL(string: url) else {
            print("Bad image URL \"\(url)\"")
            return
        }
        NasaService.downloadData(fromUrl: url) { downloadedData in
            if let data = downloadedData {
                guard let decodedImage = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.image = decodedImage
                    self?.delegate?.imageDidDownloaded()
                }
            } else {
                print("No data returned")
            }
        }
    }
}

protocol NasaImageServiceDelegate: AnyObject {
    
    func imageDidDownloaded()
    
}


