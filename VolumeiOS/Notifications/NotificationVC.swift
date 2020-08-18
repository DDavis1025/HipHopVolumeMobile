//
//  NotificationVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 7/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI



class NotificationVC: Toolbar, UITableViewDelegate, UITableViewDataSource {
    private var myTableView:UITableView!
    var notifications:[NotificationViewModel] = [] {
        didSet {
            myTableView.reloadData()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.setToolbarHidden(false, animated: false)
            self.navigationController?.isToolbarHidden = false
            
            print("navigation bar \(self.navigationController)")
        }
    }
    var profile = SessionManager.shared.profile
    var followView:FollowButtonView?
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        addTableView()
        loadNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func loadNotifications() {
           print("loadNotifications")
           if let user_id = profile?.sub {
               let getNotifications = GETNotificationsByUserID(user_id: user_id)
               getNotifications.getNotifications { notifications in
//                self.myTableView.reloadData()
                self.notifications = notifications.map { notification in
                let ret = NotificationViewModel()
                ret.mainNotification = notification
    
                return ret
             }
           }
        }
      }
    
    
    
    func addTableView() {
        
        self.myTableView = UITableView()
        
        
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.myTableView.frame.size.height = self.view.frame.height
        //
        self.myTableView.frame.size.width = self.view.frame.width
        
        
        self.myTableView.register(NotificationCell.self, forCellReuseIdentifier: "MyCell")
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.isScrollEnabled = true
        
        myTableView.delaysContentTouches = false
        self.view.addSubview(self.myTableView)
        
    
        self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.myTableView.estimatedRowHeight = 100
        self.myTableView.rowHeight = UITableView.automaticDimension
        
        
        myTableView.layoutMargins = UIEdgeInsets.zero
        myTableView.separatorInset = UIEdgeInsets.zero
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! NotificationCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.index = indexPath.row
//        let notification = self.notifications[indexPath.row]
//        cell.setNotification(notification: notification)
        let item = self.notifications[indexPath.item]
        cell.viewModel = item
        

        return cell
    }
    
    
}


extension NotificationVC: NotificationCellDelegate {
    func updateTableViewCell() {
        self.myTableView?.beginUpdates()
        self.myTableView?.endUpdates()
    }
    
    func pushToSupporterProfile(supporter_id: String) {
        let artistPFVC = ArtistProfileVC()
           let artistStruct = ArtistStruct()
           artistPFVC.artistID = supporter_id
           artistStruct.updateArtistID(newString: supporter_id)
           navigationController?.pushViewController(artistPFVC, animated: true)
    }
    
    func addFollowView(cell: NotificationCell, follower_id: String) {
        print("addFollowView")
         followView = FollowButtonView(id: follower_id)
                   if let followView = followView {
                     addChild(followView)
                     followView.view.isUserInteractionEnabled = true
//                     followView.view.sizeToFit()
                     cell.addSubview(followView.view)
                     cell.bringSubviewToFront(followView.view)
                    
//                    cell.messageTextView.trailingAnchor.constraint(equalTo: followView.view.leadingAnchor, constant: -20).isActive = true
                     
                     followView.didMove(toParent: self)
                     cell.bringSubviewToFront(followView.view)
                    
                     followView.view.translatesAutoresizingMaskIntoConstraints = false
                     followView.view.topAnchor.constraint(equalTo: cell.topAnchor, constant: 8).isActive = true
                     followView.view.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -8).isActive = true
                  followView.view.widthAnchor.constraint(equalToConstant:100).isActive = true
                      followView.view.heightAnchor.constraint(equalToConstant: 40).isActive = true
                   }
    }
    
    
    
    func goToPostView(post_id: String, type: String, parent_commentID:String?, comment_id:String, parentsubcommentid: String?, notificationType:String) {
        if type == "album" {
          let albumsTrackVC = NotificationAlbumsTrack()
          albumsTrackVC.post_id = post_id
          albumsTrackVC.comment_id = comment_id
          if let parent_commentID = parent_commentID {
           albumsTrackVC.parent_commentID = parent_commentID
          }
          if let parentsubcommentid = parentsubcommentid {
          albumsTrackVC.parentsubcommentid = parentsubcommentid
          }
          albumsTrackVC.notificationType = notificationType
          print("goToPostView notifType \(notificationType)")
          let atVC = UINavigationController(rootViewController: albumsTrackVC)
          atVC.modalPresentationStyle = .fullScreen
          self.present(atVC, animated: true, completion: nil)
        } else if type == "track" {
            let trackVC = NotificationTrackPlay()
            trackVC.captureId(id: post_id)
            trackVC.post_id = post_id
            trackVC.comment_id = comment_id
            if let parent_commentID = parent_commentID {
             trackVC.parent_commentID = parent_commentID
            }
            if let parentsubcommentid = parentsubcommentid {
            trackVC.parentsubcommentid = parentsubcommentid
            }
            trackVC.notificationType = notificationType
            let trackVCGo = UINavigationController(rootViewController: trackVC)
            trackVCGo.modalPresentationStyle = .fullScreen
            self.present(trackVCGo, animated: true, completion: nil)
        } else if type == "video" {
            let videoVC = VideoVC()
            videoVC.passId (id: post_id)
            videoVC.post_id = post_id
            videoVC.comment_id = comment_id
            if let parent_commentID = parent_commentID {
             videoVC.parent_commentID = parent_commentID
            }
            if let parentsubcommentid = parentsubcommentid {
            videoVC.parentsubcommentid = parentsubcommentid
            }
            videoVC.notificationType = notificationType
            GETMediaById(id: post_id, path: "video").getMedia { video in
                print("Get video \(video)")
                videoVC.author = video[0].author
                videoVC.video_description = video[0].description
                videoVC.video_title = video[0].title
                self.navigationController?.pushViewController(videoVC, animated: true)
              
            }
            
            
        }
    }
    
}


