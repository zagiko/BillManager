
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let noteCenter = UNUserNotificationCenter.current()
        
        let inHourButton = UNNotificationAction(identifier: Bill.inHourButtonID, title: "In one hour")
        
        let paidButton = UNNotificationAction(identifier: Bill.paidButtonID, title: "I have paid yet")
        
        let alarmCategory = UNNotificationCategory(identifier: Bill.notificationCategoryID, actions: [inHourButton, paidButton], intentIdentifiers: [], options: [])
        
        noteCenter.setNotificationCategories([alarmCategory])
        noteCenter.delegate = self
        
        
        
        
        // added in evening
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
        
    }
    
    
    
    
}

