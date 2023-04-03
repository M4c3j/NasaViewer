import Foundation

class NasaService {

    var url: String = "https://api.nasa.gov/planetary/apod?api_key=\(API_KEY)"
    var articles: [PictureOfTheDay] = []
    weak var delegate: NasaServiceGetRandomDidFinishDownloading? = nil
    
    init() {}
    
    func getFrom(day: Date) {
        
    }
    
    func getRandom(quantity: Int) {
        guard let url = URL(string: "\(self.url)&count=\(quantity)") else {
            print("Bad url in getRandom(quantity: Int) func")
            return
        }
        NasaService.downloadData(fromUrl: url) { downloadedData in
            if let data = downloadedData {
                guard let decodedData = try? JSONDecoder().decode([PictureOfTheDay].self, from: data) else {
                    print("Failed to decode data in getRandom(quantity: Int) func")
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.articles.append(contentsOf: decodedData.filter({return $0.mediaType == "image"}))
                    guard let downloadedArticles = self?.articles.count else {
                        print("failed to count downloadedArticles in getRandom")
                        return
                    }
                    if downloadedArticles < quantity {
                        self?.getRandom(quantity: quantity - downloadedArticles)
                    }
                    self?.delegate?.articlesDataDidDownloaded()
                }
            } else {
                print("No data returned in getRandom(quantity: Int) func")
            }
        }
    }

    static func downloadData(fromUrl url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No data")
                return
            }
            guard error == nil else {
                print("Error \(String(describing: error))")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Response error")
                return
            }
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Bad response, should be in 2xx, response: \(response.statusCode)")
                return
            }
            completionHandler(data)
        }.resume()
    }
}

protocol NasaServiceGetRandomDidFinishDownloading: AnyObject {
    
    func articlesDataDidDownloaded()
    
}
