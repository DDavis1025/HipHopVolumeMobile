//
//  NotificationCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 7/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    
    static var shared = NotificationCell()
    var imageLoader:DownloadImage?
    
   
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        return component
    }()
    
    lazy var username:UILabel = {
        let label = UILabel()
        label.text = ""
        label.sizeToFit()
        return label
    }()
    
    lazy var user_image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var post_image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var messageTextView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.sizeToFit()
        tv.backgroundColor = UIColor.lightGray
        tv.textContainer.maximumNumberOfLines = 0
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.font = UIFont(name: "GillSans", size: 18)
        return tv
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(user_image)
        addSubview(username)
        addSubview(messageTextView)
        addSubview(post_image)
        user_imageContraints()
        usernameContraints()
        messageConstraints()
        postImageConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNotification(notification: Notifications?) {
        print("notification sent to cell")
        if let supporter_id = notification?.supporter_id {
            GetUsersById(id: supporter_id).getAllPosts {
                self.imageLoader = DownloadImage()
                self.imageLoader?.imageDidSet = { [weak self] image in
                    self?.user_image.image = image
                }
                if let picture = $0[0].picture {
                    self.imageLoader?.downloadImage(urlString: picture)
                }
                self.username.text = $0[0].username
                if let message = notification?.message {
                self.messageTextView.text = message
                }
            }
            if let post_id = notification?.post_id {
                print("notification?.post_id \(notification?.post_id)")
                GETPostImageById(id: "e084658b-e744-4ed5-a8f4-a592d1ae6248").getPost(completion: { post in
                    print("post image path \(post[0].path)")
                    var component = URLComponents()
                    component.scheme = "http"
                    component.host = "localhost"
                    component.port = 8000
                    if let path = post[0].path {
                    component.path = "/\(path)"
                    }
                    
                    self.imageLoader = DownloadImage()
                    self.imageLoader?.imageDidSet = { [weak self] image in
                        self?.post_image.image = image
                    }
                    if let url = component.url?.absoluteString {
                    print("post image url \(url)")
                    self.imageLoader?.downloadImage(urlString: url)
                    }
                })
                
            }
                    
            } else {
            print ("supported id \(notification?.supporter_id)")
            
        }
    }
    
    func user_imageContraints() {
        user_image.translatesAutoresizingMaskIntoConstraints = false
        user_image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        user_image.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 8).isActive = true
        user_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        user_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func usernameContraints() {
        username.translatesAutoresizingMaskIntoConstraints = false
        username.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        username.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 3).isActive = true
    }
    
    func messageConstraints() {
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.centerYAnchor.constraint(equalTo: username.centerYAnchor).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: username.trailingAnchor, constant: 8).isActive = true
        messageTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80).isActive = true
    }
    
    func postImageConstraints() {
        post_image.translatesAutoresizingMaskIntoConstraints = false
        post_image.centerYAnchor.constraint(equalTo: username.centerYAnchor).isActive = true
        post_image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        post_image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        post_image.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
  
    
}
