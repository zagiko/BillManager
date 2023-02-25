
import Foundation
import UserNotifications
import UIKit

extension Bill {
    
    var hasReminder: Bool {
        return (remindDate != nil)
    }
    
    var isPaid: Bool {
        return (paidDate != nil)
    }
    
    var formattedDueDate: String {
        let dateString: String
        
        if let dueDate = self.dueDate {
            dateString = dueDate.formatted(date: .numeric, time: .omitted)
        } else {
            dateString = ""
        }
        
        return dateString
    }
    
    
    
    
    mutating func removeReminder() {
        if let id = notificationID {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            notificationID = nil
            remindDate = nil
        }
    }
    
    func autorizeIfNeeded(completion: @escaping (Bool) -> ()) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings{ (settings) in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completion(true)
                
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound],
                                                        completionHandler: { (granted, _) in
                    completion(granted)
                    
                })
            case .ephemeral:
                completion(false)
            case .denied:
                completion(false)
                
            @unknown default:
                completion(false)
                
            }
        }
    }
    
    
    
    
    mutating func schedulesReminders(date: Date, completion: @escaping (Bill) -> () ) {
        
        var updatedBill = self
        
        updatedBill.removeReminder()
        
        autorizeIfNeeded { (granted) in
            guard granted else {
                DispatchQueue.main.async {
                    completion(updatedBill)
                }
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Bill Reminder"
            content.body = String(format: "%@ due to %@ on %@", arguments: [(updatedBill.amount ?? 0).formatted(.currency(code: "usd")),(updatedBill.payee ?? ""), updatedBill.formattedDueDate])
            content.categoryIdentifier = Bill.notificationCategoryID
            content.sound = UNNotificationSound.default
            
            let triggerDateComponents = Calendar.current.dateComponents([.second,.minute,.hour,.day,.month,.year], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            
            let notificationID = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {
                (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                        
                    } else {
                        updatedBill.notificationID = notificationID
                        updatedBill.remindDate = date
                        
                    }
                    
                    DispatchQueue.main.async {
                        completion(updatedBill)
                    }
                }
            })
        }
    }
}
