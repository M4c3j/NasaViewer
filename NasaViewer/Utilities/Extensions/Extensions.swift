//
//  StringExtensions.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-04-17.
//

import Foundation
import SwiftUI

extension String {
    
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/)|(?<=shorts/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
}

extension String {
    
    var vimeoID: String? {
        let pattern = "(?<=video/)([0-9]*)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
}

extension View {
    
    @ViewBuilder func applyTextColor(_ color: Color) -> some View {
        if UITraitCollection.current.userInterfaceStyle == .light {
            self.colorInvert().colorMultiply(color)
        } else {
            self.colorMultiply(color)
        }
    }
    
}

extension Date {
    
    func firstDayOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func lastDayOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.firstDayOfMonth())!
    }
    
    func firstDayOfMonthOrFirstAPODDate() -> Date {
        let firstDay = self.firstDayOfMonth()
        guard let firstAPODDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 16)) else {
            print("Failed to unwrapp firstAPODDate in \(self)")
            return firstDay
        }
        return firstDay <  firstAPODDate ? firstAPODDate : firstDay
    }
    
    func lastDayOfMonthOrToday() -> Date {
        let lastDay = self.lastDayOfMonth()
        return lastDay > Date() ? Date() : lastDay
    }
    
    ///Returns (Date, Date) which are (startDate, endDate). Func checks if beginning date is not before first APODDate and if date is not in the future.
    func APODBStartEndDates() -> (Date, Date) {
        return (self.firstDayOfMonthOrFirstAPODDate(), self.lastDayOfMonthOrToday())
    }
    ///Return in "yyyy-MM-dd" string format
    func getFormattedDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    ///Returns formatted start date in 2023-05-10 format
    func getAndFormatStartDateToString() -> String {
        APODBStartEndDates().0.getFormattedDateToString()
    }
    
    ///Returns formatted end date in 2023-05-10 format
    func getAndFormatEndDateToString() -> String {
        APODBStartEndDates().1.getFormattedDateToString()
    }
}

