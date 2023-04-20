//
//  PictureOfTheDayModel.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-03-22.
//

import Foundation

struct PictureOfTheDay: Codable {
    let concepts, copyright, date, explanation: String?
    let hdurl: String?
    let mediaType, serviceVersion, title: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case concepts, copyright, date, explanation, hdurl, title, url
        case mediaType = "media_type"
        case serviceVersion = "service_version"
    }
    
#if DEBUG
    static func getExampleData() -> [PictureOfTheDay]? {
        if let url = Bundle.main.url(forResource: "ExamplePictureOfTheDay", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([PictureOfTheDay].self, from: data)
                return jsonData
            } catch {
                print("An error has occured in getExampleData. Description: \(error)")
            }
        }
        return nil
    }
#endif
}



