//
//  AppDelegate.swift
//  WeatherANDNewsApp
//
//  Created by Мария Манжос on 12.09.21.
//

import UIKit
import AlamofireNetworkActivityLogger
import GoogleMaps
import UserNotifications
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //отмена нотифиации
        notificationCenter.getPendingNotificationRequests { requests in
            //удаление нотификации
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: ["notification_5_days"])
        }

        //запрос на отправку уведомлений
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { isOn, error in
            guard isOn else {return}
            //проверка настроек уведомления, кот установил пользователь
            self.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else {return}
                self.sendNotification()
            }
        }
        
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyDHSqEJIQhoeasvJwPg6kjIy_YxM0uNCfU")
        
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug

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
    
    private func sendNotification() {
        //создаем уведомление
        let content = UNMutableNotificationContent()
        content.title = "What's the weater today?"
        content.body = "Check the weather in your city"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.userInfo = ["Current_vc" : "WeatherViewController"]
        
        //создаем событие по которому будет отправляться уведомление
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20.0, repeats: false)
        
        //создаем запрос на отправку уведомления
        let request = UNNotificationRequest(identifier: "notification_5_days", content: content, trigger: trigger)
        
        //добавляем запрос
        notificationCenter.add(request) { error in
            guard let error = error else {return}
            print("\(error.localizedDescription)")
        }
        print("Add notification")
    }
}

