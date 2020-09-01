//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by twave on 2020/09/01.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, #file)
        print("###############")
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: size.height)
        // Do any required interface initialization here.
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        label?.text = content.title + "기아 김숸빈"
        
//        guard let item = notification.request.content.attachments.first else { return }
//
//
//        print(content)
//        self.label?.text = notification.request.content.body
//        print(#function, "############", content.title)
        
        let attachments = notification.request.content.attachments
        //newsImage.jpg
        for attachment in attachments {
            if attachment.identifier == "newsImage.jpg" {
                print("imagreUrl : ", attachment.url)
                guard let data = try? Data(contentsOf: attachment.url) else {
                    return
                }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
//    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
//        print(response)
//
//
//
//        print(#function)
//    }

}

extension UNNotificationAttachment {

    static func saveImageToDisk(fileIdentifier: String, data: Data, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)

        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            print("error \(error)")
        }

        return nil
    }
    
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
