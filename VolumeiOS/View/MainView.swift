//
//  MainView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/24/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Auth0

class MainView: Toolbar, UITableViewDelegate, UITableViewDataSource {
    
    private var myTableView: UITableView!
    var model:PostListViewModel?
    var child:SpinnerViewController?
    var cellTitle:UILabel?
    var cellDesc:UILabel?
    var userModel:GetUserByIDVM?
    var posts = [Post]() {
        didSet {
            myTableView.reloadData()
            self.child?.willMove(toParent: nil)
            self.child?.view.removeFromSuperview()
            self.child?.removeFromParent()

        }
    }
    var albumVC:AlbumVC?
    var imageLoader:DownloadImage?
    
    var components:URLComponents = {
           var component = URLComponents()
           component.scheme = "http"
           component.host = "localhost"
           component.port = 8000
           return component
       }()
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        addSpinner()
        Webservice().getAllPosts {
            self.posts = $0
        }
        

        
        let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addTapped))
                   
        let whoToFollow = UIBarButtonItem(title: "toFollow", style: .plain, target: self, action: #selector(toFollowTapped))

       navigationItem.leftBarButtonItem = profile
       navigationItem.rightBarButtonItem = whoToFollow
        
        addTableView()

        
        view.isUserInteractionEnabled = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        auth0()
    }
    
    func auth0() {
        Auth0
        .webAuth()
        .scope("openid offline_access profile")
        .audience("https://dev-owihjaep.auth0.com/userinfo")
        .start {
            switch $0 {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let credentials):
                print(credentials.accessToken)
                if(!SessionManager.shared.store(credentials: credentials)) {
                    print("Failed to store credentials")
                } else {
                    SessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            guard error == nil else {
                                print("Failed to retrieve profile: \(String(describing: error))")
                                return
                        }
                      }
                    }
                }
            }
        }
    }
    
    @objc func addTapped() {
           let profileVC = ProfileViewController()
           self.navigationController?.pushViewController(profileVC, animated: true)
       }
       
   @objc func toFollowTapped() {
       let toFollowVC = WhoToFollowVC()
       self.navigationController?.pushViewController(toFollowVC, animated: true)
   }
    
    func addSpinner() {
             let child = SpinnerViewController()
             addChild(child)
             child.view.frame = view.frame
             view.addSubview(child.view)
             child.didMove(toParent: self)
             child.view.backgroundColor = UIColor.white
             self.view.bringSubviewToFront(child.view)
       }
    

    
    
    func addTableView() {
        
            self.myTableView = UITableView()
                    
                    
            self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
                            
            self.myTableView.frame.size.height = self.view.frame.height
        //
            self.myTableView.frame.size.width = self.view.frame.width
                    
                            
            self.myTableView.register(FeedCell.self, forCellReuseIdentifier: "MyCell")
           
                            self.myTableView.dataSource = self
                            self.myTableView.delegate = self
                            self.myTableView.isScrollEnabled = true
                    
            myTableView.delaysContentTouches = false
            self.view.addSubview(self.myTableView)
            
            self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

            self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

            self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
            myTableView.layoutMargins = UIEdgeInsets.zero
            myTableView.separatorInset = UIEdgeInsets.zero
            
                    
                    

       

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 140
       }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        albumVC = AlbumVC(post: posts[indexPath.row])
        navigationController?.pushViewController(albumVC!, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! FeedCell
        let post = posts[indexPath.row]
        cell.set(post: post)
//        cell.albumImage.image = nil

        return cell
    }

}
