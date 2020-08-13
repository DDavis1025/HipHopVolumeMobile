//
//  NotificationViewModel.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 7/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit
import Foundation

class NotificationViewModel {
    var mainNotification: Notifications? {
        didSet {
            if let notificationMessage = mainNotification?.message {
                   if notificationMessage.contains("replied to your comment") {
                       notificationType = "reply"
                       notificationTypeDidSet?("reply")
                   } else if notificationMessage.contains("liked your comment") {
                       notificationType = "likedComment"
                       notificationTypeDidSet?("likedComment")
                   } else if notificationMessage.contains("started following you") {
                       notificationType = "follow"
                       notificationTypeDidSet?("follow")
                   } else if notificationMessage.contains("liked your post") {
                       notificationType = "likedPost"
                       notificationTypeDidSet?("likedPost")
                   } else if notificationMessage.contains("commented on your post") {
                       notificationType = "commentedPost"
                       notificationTypeDidSet?("commentedPost")
                   }
            }
        }
    }
    var supporterImageDownloader: DownloadImage?
    var postImageDownloader: DownloadImage?
    var notificationType: String? { didSet { notificationTypeDidSet?(notificationType) } }
    var notificationTypeDidSet: ((String?)->())?
    
    
    
 }
    
    



