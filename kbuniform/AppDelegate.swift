//
//  AppDelegate.swift
//  kbuniform
//
//  Created by twave on 2020/08/31.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("[Log] deviceToken :", deviceTokenString)
        
        
        Messaging.messaging().apnsToken = deviceToken
        print(deviceToken)
    }
    
    
    
    /*
     CoreData Stack
     */
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "kbuniform")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    open class DownloadManager: NSObject {

        open class func image(_ URLString: String) -> String? {

            let componet = URLString.components(separatedBy: "/")

            if let fileName = componet.last {

                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

                if let documentsPath = paths.first {

                    let filePath = documentsPath.appending("/" + fileName)

                    if let imageURL = URL(string: URLString) {

                        do {

                            let data = try NSData(contentsOf: imageURL, options: NSData.ReadingOptions(rawValue: 0))

                            if data.write(toFile: filePath, atomically: true) {

                                return filePath

                            }

                        } catch {

                            print(error)

                        }

                    }

                }

            }

            

            return nil

        }

    }
    
}
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //앱이 포그라운드에 있을 때 호출되는 메서드
        print(#function)
        
        let userInfo = notification.request.content.userInfo
        //앱이 떠있을 때, 앱이 포그라운드 있을 때 호출됨.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        let content = UNMutableNotificationContent()
        if let options = userInfo["fcm_options"] as? NSDictionary {
            if let imagePath = options["image"] as? String {
                let imagas = DownloadManager.image(imagePath)
                let imageURL = URL(fileURLWithPath: imagas!)
                do {
                    let attach = try UNNotificationAttachment(identifier: "image-test", url: imageURL, options: nil)
                    content.attachments = [attach]
                    
//                    let attach = try UNNotificationAttachment(identifier: "image-test", url: URL(string: imagePath)!, options: nil)
//                    content.attachments = [attach]
//                    let imageData = NSData(contentsOf: URL(string: imagePath)!)
//                    guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "img.jpeg", data: imageData!, options: nil) else {return}
//                    content.attachments = [attachment]
                }catch {
                    print(error)
                }
            }
        }
        content.title = "FFFFFFF"
        content.body = "육회가 먹고 싶다."
        center.delegate = self
//        let request = UNNotificationRequest(identifier: "Image_TEST", content: content, trigger: nil) // Schedule the notification.
//        center.add(request, withCompletionHandler: { (error) in
//            print("Error ===== ", error)
//            return
//        })
//
//        center.add(request){ (error : Error?) in
//            if let theError = error {
//                print(theError)
//            }
//        }

        
        // Print full message.
        print("userNotificationCenter completionHandler UNNotificationPresentationOptions \(userInfo)")
        
        completionHandler([.alert, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
        /*
         Notification의 응답에 대한 처리를 해줄 수 있는 메서드
         1. 유저가 Notificaton을 종료 했을 때,
         2. 유저가 Notificaton을 열었을 때
         */
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        let content = UNMutableNotificationContent()
        if let options = userInfo["fcm_options"] as? NSDictionary {
            if let imagePath = options["image"] as? String {
                do {
//                    let imageData = NSData(contentsOf: URL(string: imagePath)!)
//                    let attach = try UNNotificationAttachment(identifier: "image-test", url: URL(string: imagePath)!, options: nil)
//                    content.attachments = [attach]
                    let imageData = NSData(contentsOf: URL(string: imagePath)!)
                    guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "img.jpeg", data: imageData!, options: nil) else {return}
                    content.attachments = [attachment]
                }catch (let error){
                    print(error)
                }
            }
        }
        content.title = "FFFFFFF"
        content.body = "육회가 먹고 싶다."
        let request = UNNotificationRequest(identifier: "Image_TEST", content: content, trigger: nil) // Schedule the notification.
        center.delegate = self
        center.add(request){ (error : Error?) in
            if let theError = error {
                print(theError)
                return
            }
        }

        completionHandler()
    
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(#function, userInfo)
        //           if let data = Mapper<FCMData>().map(JSONObject: userInfo) {
        //               imagePush(data: data)
        //           }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(#function, userInfo)
        
        //           if let data = Mapper<FCMData>().map(JSONObject: userInfo) {
        //               imagePush(data: data)
        //           }
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


extension AppDelegate :  MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //생성이 되고나면, 바뀌지 않으면 여기를 타는 듯 하다.
        //최초 설치 이후, 앱을 재설치 하더라도, 이 부분을 타고, 이 전의 token값을 바꿔준다.
        //새로 받은 토큰 값을 apnstoken과 같이 바꾸는 지는 확인해볼 필요가 있음.
        /*
         1. 새 기기에서 앱 복원
         2. 유저가 앱 삭제 / 재설치
         3. 유저가 앱 데이터 소거
         */
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                //            self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        print(#function, fcmToken)
    }
}
/*
 최소 버전을 ios 13.0이상으로 올렸을 경우 주석을 풀어야한다.
 
 */
// MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

/*
 13.0이상으로 올렸을 경우 다시 재 사용한다.
 
 - Appdelegate의 var window:UIWindow? 도 제거
 
 <key>UIApplicationSceneManifest</key>
 <dict>
 <key>UIApplicationSupportsMultipleScenes</key>
 <false/>
 <key>UISceneConfigurations</key>
 <dict>
 <key>UIWindowSceneSessionRoleApplication</key>
 <array>
 <dict>
 <key>UISceneConfigurationName</key>
 <string>Default Configuration</string>
 <key>UISceneDelegateClassName</key>
 <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
 <key>UISceneStoryboardFile</key>
 <string>Main</string>
 </dict>
 </array>
 </dict>
 </dict>
 
 */
extension UNNotificationAttachment {
    
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL!, options: [])
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL!, options: options)
            return imageAttachment
        } catch let error {
            print("error \(error)")
        }
        return nil
    }
    
}
