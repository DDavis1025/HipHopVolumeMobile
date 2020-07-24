//
//  NotificationVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 7/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit



class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var myTableView:UITableView!
    var notifications:[Notifications] = [] {
        didSet {
            myTableView.reloadData()
        }
    }
    var profile = SessionManager.shared.profile
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationController?.isToolbarHidden = true
        addTableView()
        loadNotifications()
    }

    func loadNotifications() {
        print("loadNotifications")
        if let user_id = profile?.sub {
            let getNotifications = GETNotificationsByUserID(user_id: user_id)
            getNotifications.getNotifications {
                print("notifications load \($0)")
                self.notifications = $0
         }
        } else {
            print("user_id profile sub \(profile?.sub)")
        }
            self.myTableView.reloadData()
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
        
        self.myTableView.estimatedRowHeight = 80
        self.myTableView.rowHeight = UITableView.automaticDimension
        
        
        myTableView.layoutMargins = UIEdgeInsets.zero
        myTableView.separatorInset = UIEdgeInsets.zero
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! NotificationCell
        
        let notification = self.notifications[indexPath.row]
        cell.setNotification(notification: notification)
        

        return cell
    }
    
    
}


