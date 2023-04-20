import Foundation

class NasaService {

    var url: String = "https://api.nasa.gov/planetary/apod?api_key=\(API_KEY)"
    var articles: [PictureOfTheDay] = []
    weak var delegate: NasaServiceGetRandomDidFinishDownloading? = nil
    
    init() {}
    
    func getFrom(month: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //check if date is not before first APOD
        let firstDayOfMonth: Date = {
            let firstDay = month.firstDayOfMonth()
            guard let firstAPODDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 16)) else {
                print("Failed to unwrapp firstAPODDate in \(self)")
                return firstDay
            }
            if firstDay <  firstAPODDate {
                return firstAPODDate
            } else {
                return firstDay
            }
        }()
        let beginingDate = dateFormatter.string(from: firstDayOfMonth)
        //check if date is not after latest apod
        let lastDayOfMonth: Date = {
            let lastDay = month.lastDayOfMonth()
            if lastDay > Date() {
                return Date()
            } else {
                return lastDay
            }
        }()
        let endDate = dateFormatter.string(from: lastDayOfMonth)
        guard let url = URL(string: "\(self.url)&start_date=\(beginingDate)&end_date=\(endDate)") else {
            print("Bad url in getFrom(day: Date)")
            return
        }
        print(url.absoluteString)
        NasaService.downloadData(fromUrl: url) { downloadedData in
            if let data = downloadedData {
                guard let decodedData = try? JSONDecoder().decode([PictureOfTheDay].self, from: data) else {
                    print("Failed to decode data in getRandom(quantity: Int) func")
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.articles = decodedData
                    self?.delegate?.articlesDataDidDownloaded()
                }
            } else {
                print("No data returned in getRandom(quantity: Int) func")
            }
        }
    }


    
    func getFrom(day: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: day)
        print(stringDate)
        guard let url = URL(string: "\(self.url)&date=\(stringDate)") else {
            print("Bad url in getFrom(day: Date)")
            return
        }
        NasaService.downloadData(fromUrl: url) { downloadedData in
            if let data = downloadedData {
                guard let decodedData = try? JSONDecoder().decode(PictureOfTheDay.self, from: data) else {
                    print("Failed to decode data in getRandom(quantity: Int) func")
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.articles = [decodedData]
                    self?.delegate?.articlesDataDidDownloaded()
                }
            } else {
                print("No data returned in getRandom(quantity: Int) func")
            }
        }
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
                    self?.articles = decodedData
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
