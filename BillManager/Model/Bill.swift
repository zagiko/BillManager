
import Foundation
import UserNotifications

struct Bill: Codable {
    let id: UUID
    var amount: Double?
    var dueDate: Date?
    var paidDate: Date?
    var payee: String?
    var remindDate: Date?
    
    static let notificationCategoryID = "CustomAlert"
    static let inHourButtonID = "inHourButton"
    static let paidButtonID = "paidButtonID"
    
    init(id: UUID = UUID()) {
        self.id = id
    }
    
    func schedule(completion: @escaping (Bool) -> ()) {
        permitionCheck { (granted) in
            guard granted else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            // Create push content
            
            let content = UNMutableNotificationContent()
            content.title = "Please pay bill"
            
            guard let textBody = self.payee else {
                return
            }
            content.body = "\(textBody)"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = Bill.notificationCategoryID
            
            // Create push conditions
            
            guard let trigerDate = self.remindDate else {
                return }
            
            let triggerDataComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: trigerDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDataComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: Bill.notificationCategoryID, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                (error: Error?) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                        } else {
//                            Database.shared.save()
                            completion(true)
                    }
                }
            }
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
}

extension Bill: Hashable {
    //    static func ==(_ lhs: Bill, _ rhs: Bill) -> Bool {
    //        return lhs.id == rhs.id
    //    }
    //
    //    func hash(into hasher: inout Hasher) {
    //        hasher.combine(id)
    //    }
}
