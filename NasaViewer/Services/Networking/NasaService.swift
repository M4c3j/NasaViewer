import Foundation

final class NasaService {
    // Może móglbyś to wynieść do jakiegoś innego miejsca np. enuma z urlami?
    // https://www.swiftbysundell.com/articles/constructing-urls-in-swift/
    // https://www.swiftbysundell.com/articles/creating-generic-networking-apis-in-swift/
    
    var components = URLComponents()
    var url: String = "https://api.nasa.gov/planetary/apod?api_key=\(API_KEY)"
    var articles: [PictureOfTheDay] = []
    weak var delegate: NasaServiceGetRandomDidFinishDownloading? = nil
    
    init() {
        components.scheme = "https"
        components.host = "api.nasa.gov"
        components.path = "/planetary/apod"
    }
    
    func getFrom(day: Date) throws {
        self.components.queryItems = [
            URLQueryItem.init(name: APODURL.apiKey.rawValue, value: API_KEY),
            URLQueryItem(name: APODURL.day.rawValue, value: day.getFormattedDateToString())
        ]
        try fetchData(isMoreThanOneArticle: false)
    }
    
    func getFrom(month: Date) throws {
        self.components.queryItems = [
            URLQueryItem.init(name: APODURL.apiKey.rawValue, value: API_KEY),
            URLQueryItem(name: APODURL.startDay.rawValue, value: month.getAndFormatStartDateToString()),
            URLQueryItem(name: APODURL.endDay.rawValue, value: month.getAndFormatEndDateToString())
        ]
        try fetchData(isMoreThanOneArticle: true)
    }
    
    func getRandom(quantity: Int) throws {
        self.components.queryItems = [
            URLQueryItem.init(name: APODURL.apiKey.rawValue, value: API_KEY),
            URLQueryItem(name: APODURL.random.rawValue, value: String(quantity))
        ]
        try fetchData(isMoreThanOneArticle: true)
    }
    
    private func fetchData(isMoreThanOneArticle: Bool) throws {
        guard let url = components.url else {
            throw NasaServiceError.badUrl
        }
        let data = try NasaService.downloadData(fromUrl: url)
        let decodedData = try JSONDecoder().decode([PictureOfTheDay].self, from: data)
        if isMoreThanOneArticle {
            let decodedData = try JSONDecoder().decode([PictureOfTheDay].self, from: data)
            DispatchQueue.main.async {
                self.articles = decodedData
                self.delegate?.articlesDataDidDownloaded()
            }
        } else {
            let decodedData = try JSONDecoder().decode(PictureOfTheDay.self, from: data)
            DispatchQueue.main.async {
                self.articles = [decodedData]
                self.delegate?.articlesDataDidDownloaded()
            }
        }
    }
    
    static func downloadData(fromUrl url: URL) throws -> Data {
        var responseData: Data?
        var responseError: Error?
        var urlResponse: URLResponse?
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            responseData = data
            responseError = error
            urlResponse = response
            semaphore.signal()
        }.resume()
        semaphore.wait()
        guard let data = responseData else {
            throw NasaServiceError.noDataReturned
        }
        guard let response = urlResponse as? HTTPURLResponse else {
            throw NasaServiceError.responseError
        }
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            throw NasaServiceError.badResponse(statusCode: response.statusCode)
        }
        if let error = responseError {
            throw error
        }
        return data
    }
    
//    private func fetchData(isMoreThanOneArticle: Bool) throws {
//        guard let url = components.url else {
//            throw NasaServiceError.badUrl
//        }
//        throw NasaServiceError.badUrl
//        NasaService.downloadData(fromUrl: url) { [weak self] data in
//            guard let data = data else {
//                throw NasaServiceError.noDataReturned
//            }
//            if isMoreThanOneArticle {
//                let decodedData = try JSONDecoder().decode([PictureOfTheDay].self, from: data)
//                DispatchQueue.main.async {
//                    self?.articles = decodedData
//                    self?.delegate?.articlesDataDidDownloaded()
//                }
//            } else {
//                let decodedData = try JSONDecoder().decode(PictureOfTheDay.self, from: data)
//                DispatchQueue.main.async {
//                    self?.articles = [decodedData]
//                    self?.delegate?.articlesDataDidDownloaded()
//                }
//            }
//        }
//    }
//
//    static func downloadData(fromUrl url: URL, completionHandler: @escaping (_ data: Data?) throws -> ()) {
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                print("No data")
//                return
//            }
//            guard error == nil else {
//                print("Error \(String(describing: error))")
//                return
//            }
//            guard let response = response as? HTTPURLResponse else {
//                print("Response error")
//                return
//            }
//            guard response.statusCode >= 200 && response.statusCode < 300 else {
//                print("Bad response, should be in 2xx, response: \(response.statusCode)")
//                return
//            }
//            try? completionHandler(data)
//        }.resume()
//    }
    
}

enum NasaServiceError: Error {
    case noDataReturned
    case failedToDecodeData
    case badUrl
    case responseError
    case badResponse(statusCode: Int)
}



protocol NasaServiceGetRandomDidFinishDownloading: AnyObject {
    
    func articlesDataDidDownloaded()
    
}
