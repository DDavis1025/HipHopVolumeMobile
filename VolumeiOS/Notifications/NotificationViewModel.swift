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
    var mainNotification: Notifications?
    var supporter_info:UsersModel?
    var imageLoader: DownloadImage?
    var supporterName: String? { didSet { supporterNameDidSet?(supporterName) } }
    var supporterNameDidSet: ((String?)->())?
    var supporterImage: UIImage? = UIImage()  { didSet { supporterImageDidSet?(supporterImage) } }
    var supporterImageDidSet: ((UIImage?)->())?
    var gotSupporter:Bool = false
    
    func getUserBySupporterID(supporter_id:String) {
        GetUsersById(id: supporter_id).getAllPosts { user in
            print("GetUsersById \(supporter_id) + \(user)")
            self.gotSupporter = true
            
            self.imageLoader = DownloadImage()
            self.imageLoader?.imageDidSet = { [weak self] image in
                self?.supporterImage = image
                self?.supporterImageDidSet?(image)
            }
            if let picture = user[0].picture {
                self.imageLoader?.downloadImage(urlString: picture)
            }
            self.supporterName = user[0].username
            self.supporterNameDidSet?(user[0].username)

    }
 }
    
    
    
    
}



