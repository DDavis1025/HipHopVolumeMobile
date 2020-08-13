//
//  NotificationCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 7/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationCellDelegate {
    func goToPostView(post_id: String, type: String, parent_commentID:String?, comment_id:String, parentsubcommentid:String?, notificationType:String)
    func addFollowView(cell:NotificationCell, follower_id:String)
    func pushToSupporterProfile(supporter_id:String)
    func updateTableViewCell()
}



class NotificationCell: UITableViewCell {
    
    static var shared = NotificationCell()
    var profile = SessionManager.shared.profile
    var imageLoader:DownloadImage?
    var delegate:NotificationCellDelegate?
    var post_id:String?
    var post_type:String?
    var comment_id:String?
    var supporter_id:String?
    var parent_commentID:String?
    var parentsubcommentid:String?
    var notificationType:String?
    var isFollow:Bool? = false
    var index:Int?
    var messageTextViewBtm:NSLayoutConstraint?
    var viewModel: NotificationViewModel? {
            didSet {
                if let item = viewModel {
                    
                    
                    self.username.text = item.mainNotification?.supporter_username
                    item.supporterImageDownloader = DownloadImage()
                    item.supporterImageDownloader?.imageDidSet = { [weak self] image in
                        self?.user_image.image = image
                    }
                    if let picture = item.mainNotification?.supporter_picture {
                        item.supporterImageDownloader?.downloadImage(urlString: picture)
                    } else {
                        self.user_image.image = UIImage(named: "profile-placeholder-user")
                    }
            
                    
                    item.postImageDownloader = DownloadImage()
                    item.postImageDownloader?.imageDidSet = { [weak self] image in
                        self?.post_image.image = image
                    }
                    if let picture = item.mainNotification?.post_image {
                        components.path = "/\(picture)"
                        if let url = components.url {
                            item.postImageDownloader?.downloadImage(urlString: url.absoluteString)
                        }
                    } else {
                        self.post_image.image = UIImage(named: "music-placeholder")
                    }
                    
                    
                    if let text = item.mainNotification?.message {
                    self.messageTextView.text = "\(text)"
                    }
//
                    self.notificationType = item.notificationType
                    if self.notificationType == "likedComment"  {
                        print("hello1")
                        self.commentConstraints()
                        if let parent_comment = item.mainNotification?.parent_comment {
                        self.commentTextView.text = "- \(parent_comment)"
                        }
                    } else if self.notificationType == "reply" && item.mainNotification?.parent_commentid != nil || item.mainNotification?.parentsubcommentid != nil {
                        self.commentConstraints()
                        if let parent_comment = item.mainNotification?.parent_comment {
                        self.commentTextView.text = "- \(parent_comment)"
                      }
                    }  else {
                        self.commentTextView.text = ""
                    }
                
                
                    
              }
            }
        }
    

    
   
    
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
        label.font = label.font.withSize(19)
        label.sizeToFit()
        return label
    }()
    
    lazy var user_image: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(userImageClicked))
        image.addGestureRecognizer(gesture)
        return image
    }()
    
    lazy var comment_symbol: UIImageView = {
        let imageView = UIImageView()
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .small)
        let smallSymbolImage = UIImage(systemName: "arrowtriangle.right.fill", withConfiguration: smallConfiguration)
        imageView.image = smallSymbolImage
        imageView.tintColor = UIColor.gray
        return imageView
    }()
    
    lazy var post_image: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(postImageClicked))
        image.addGestureRecognizer(gesture)
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
    
    lazy var commentTextView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.sizeToFit()
//        tv.backgroundColor = UIColor.gray
        tv.textColor = UIColor.gray
        tv.textContainer.maximumNumberOfLines = 1
        tv.textContainer.lineBreakMode = .byTruncatingTail
        tv.font = UIFont(name: "GillSans", size: 18)
        return tv
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(username)
        addSubview(user_image)
        addSubview(messageTextView)
        addSubview(post_image)
        addSubview(commentTextView)
        user_imageContraints()
        usernameContraints()
        messageConstraints()
        commentConstraints()
        postImageConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    func user_imageContraints() {
        user_image.translatesAutoresizingMaskIntoConstraints = false
//        user_image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        user_image.topAnchor.constraint(equalTo:topAnchor, constant: 8).isActive = true
        user_image.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 8).isActive = true
        user_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        user_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func usernameContraints() {
        username.translatesAutoresizingMaskIntoConstraints = false
        username.topAnchor.constraint(equalTo: user_image.topAnchor).isActive = true
        username.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 3).isActive = true
        username.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func messageConstraints() {
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.topAnchor.constraint(equalTo: username.bottomAnchor).isActive = true
//        messageTextViewBtm = messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
//        messageTextViewBtm?.isActive = true
        
        messageTextView.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 3).isActive = true
        
        messageTextView.trailingAnchor.constraint(equalTo: post_image.leadingAnchor, constant: -5).isActive = true
    }
    
    func commentConstraints() {
//        addSubview(comment_symbol)
//        messageTextViewBtm?.isActive = false
//        comment_symbol.translatesAutoresizingMaskIntoConstraints = false
//        comment_symbol.centerYAnchor.constraint(equalTo: commentTextView.centerYAnchor).isActive = true
//        comment_symbol.leadingAnchor.constraint(equalTo: messageTextView.leadingAnchor).isActive = true
        
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        commentTextView.leadingAnchor.constraint(equalTo:  messageTextView.leadingAnchor, constant: 2.5).isActive = true
        commentTextView.trailingAnchor.constraint(equalTo: messageTextView.trailingAnchor).isActive = true
        
               
    }
    
    
    
    func postImageConstraints() {
        post_image.translatesAutoresizingMaskIntoConstraints = false
        post_image.topAnchor.constraint(equalTo: user_image.topAnchor).isActive = true
        post_image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        post_image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        post_image.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
  
    @objc func userImageClicked() {
        if let supporter_id = supporter_id {
            delegate?.pushToSupporterProfile(supporter_id: supporter_id)
        }
    }

}

extension NotificationCell {
    @objc func postImageClicked() {
        print("notificationType \(notificationType)")
        print("postImageClicked \(self.parentsubcommentid)")
        if let post_id = viewModel?.mainNotification?.post_id, let post_type = viewModel?.mainNotification?.post_type, let notificationType = notificationType, let comment_id = viewModel?.mainNotification?.comment_id {
            delegate?.goToPostView(post_id: post_id, type: post_type, parent_commentID: self.parent_commentID ?? nil, comment_id: comment_id, parentsubcommentid: viewModel?.mainNotification?.parentsubcommentid ?? nil, notificationType: notificationType)
     } 
   }
}
