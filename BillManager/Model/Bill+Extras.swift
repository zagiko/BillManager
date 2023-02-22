
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
    
    
    func deleteReminder() {
        
        
    
    }
    
    mutating func schedulesReminders(date: Data, completion: @escaping (Bill) -> () ) {
        
        
    }
    
    private func authorizationToDisplay(completion: @escaping (Bool) -> () ) {
        
    }
    
    
    
    
    
    func permitionCheck(completion: @escaping (Bool) -> ()) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings{ (settings) in
            
            switch settings.authorizationStatus {
                
            case.authorized:
                completion(true)
                
            case.notDetermined:
                notificationCenter.requestAuthorization(options: [.sound], completionHandler: {
                    (granted, _) in
                    completion(granted)
                })
                
            case .denied, .provisional, .ephemeral:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
        
    }
    

    
}
