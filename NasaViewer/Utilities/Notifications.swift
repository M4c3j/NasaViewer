//
//  Notifications.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-04-19.
//

import Foundation
import UIKit
import UserNotifications

extension APODMainMenuViewController {
    
    func checkforPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            case .authorized:
                self.dispatchNotification()
            default:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            }
        }
    }
    
    func dispatchNotification() {
        #warning("Change title and try to get it from URL instead")
        let identifier = "MainNotification"
        let title = "Have you already checked todays APOD?"
        let body = "Check todays Astronomy Picture of the Day"
        let hour = 23
        let minute = 07
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    
}
