//
//  URLs.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-04-24.
//

import Foundation

enum APODURL: String {
    case apiKey = "api_key"
    case random = "count"
    case day = "date"
    case startDay = "start_date"
    case endDay = "end_date"
}

enum APODQuerry {
    case random
    case fromOneDay
    case fromOneMonth
}
