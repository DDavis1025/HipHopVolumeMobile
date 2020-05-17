//
//  ArtistProfileVC.swift
//  Test
//
//  Created by Dillon Davis on 4/16/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Auth0
import SwiftUI


class ArtistProfileVC: Toolbar, UITableViewDelegate, UITableViewDataSource {

    var profile: UserInfo!
    var isLoaded:Bool? = false
    var imageView:UIImageView!
    var myTableView: UITableView!
    var author:[PostById]!
    var album:[Post]!
    var images:[UIImage]?
    var imageLoader:DownloadImage?
    var imageLoaded:Bool? = false
    var followUsersVC:FollowUsers?
    var usersWhoFollowVC:FollowUsers?
    let stackview = UIStackView()
    var button = UIButton()
    
    var post:Post? {
        didSet {
            let vc = AlbumVC(post: self.post!)
            self.navigationController?.pushViewController(vc, animated: true)
            print("posty \(post)")
        }
    }
    var label:UILabel? = nil
    var followingLabel = UILabel()
    var followingTitle = UILabel()
    var followsLabel = UILabel()
    var followsTitle = UILabel()
    var child:SpinnerViewController?
    var users = [UsersModel]() {
        didSet {
            DispatchQueue.main.async {
                print("usersdid \(self.users)")
                self.userInfo()
                self.setContraints()
            }
        }
    }
    
    var usersFollowed = [UsersModel]() {
        didSet {
                self.followUsersVC = FollowUsers(users: self.usersFollowed)
//                self.usersWhoFollowLabels()
                followingLabel.text = String(usersFollowed.count)
                followingTitle.isHidden = false
                followingLabel.isHidden = false
//                self.followLabels()
        }
    }
    
    var usersWhoFollow = [UsersModel]() {
           didSet {
                    self.usersWhoFollowVC = FollowUsers(users: self.usersWhoFollow)
                    followsLabel.text = String(usersWhoFollow.count)
                    followsTitle.isHidden = false
                    followsLabel.isHidden = false
//                    self.usersWhoFollowLabels()
//                    self.followLabels()
          }
       }
    var artistData = [ArtistModel]() {
        didSet {
            DispatchQueue.main.async {
                self.child?.willMove(toParent: nil)
                self.child?.view.removeFromSuperview()
                self.child?.removeFromParent()
                self.myTableView.reloadData()
                print("Artist Data \(self.artistData)")
                print("worked")
                self.isLoaded = true

            }
        }
    }
    var posts:Array<Any> = []
    var artistID:String?

    var following = [Following]() {
              didSet {
                   for followed in self.following {
                    GetUsersById(id: followed.user_id!).getAllPosts {
                        self.usersFollowed.append(contentsOf: $0)
                        print("usersFollowed \(self.usersFollowed.count)")
                    }
                  }
                  
              }
          }
    var follows = [Follows]() {
        didSet {
            for follow in follows {
                GetUsersById(id: follow.follower_id!).getAllPosts {
                  self.usersWhoFollow.append(contentsOf: $0)
                  print("usersFollowing \(self.usersWhoFollow.count)")
              }
            }
            
        }
    }
    
    
    static var shared = ArtistProfileVC()
    
    
    
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
            addTableView()

            addImagePH()
            
                if let artistID = self.artistID {
                self.getArtist(id: artistID)
                self.getFollowers(id: artistID)
            }
            
            self.usersWhoFollowLabels()
            self.followLabels()

            
            view.backgroundColor = UIColor.white
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
       userPhotoUpdated()
    }
    
    func userPhotoUpdated() {
        profile = SessionManager.shared.profile
        if EditPFStruct.photoDidChange! {
         if let profile = profile {
            print("hellur 2")
                   GetUsersById(id: profile.sub).getAllPosts {
                       let photo = $0
                       self.imageLoader = DownloadImage()
                       self.imageLoader?.imageDidSet = { [weak self] image in
                           DispatchQueue.main.async {
                               self?.imageView.image = image
                               self?.view?.addSubview(self!.imageView)
                           }
                       }
                       self.imageLoader?.downloadImage(urlString: photo[0].picture!)
                       print("photo \(photo[0].picture)")
                   }
               }
        }
    }
    
    func setContraints() {
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        self.myTableView?.topAnchor.constraint(equalTo: self.label!.bottomAnchor, constant: 20).isActive = true
    }
    
    func addImagePH() {
           let imagePH = UIImage(named:"profile-placeholder-user")
           self.imageView = UIImageView(image: imagePH)
           self.view?.addSubview(self.imageView)
           setImageContraints()
    }
    
    func setImageContraints() {
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.imageView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView?.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.imageView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
}
    
    func userInfo() {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
            label?.textAlignment = .center
            self.view.addSubview(label!)
            label?.translatesAutoresizingMaskIntoConstraints = false
            label?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            label?.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
            label?.text = "\(self.users[0].username ?? "undefined")"

            imageLoader = DownloadImage()
                self.imageLoader?.imageDidSet = { [weak self] image in
                DispatchQueue.main.async {
                self?.imageView.image = image
                self?.view?.addSubview(self!.imageView)
                }
                self?.setImageContraints()
                }
        if let user_pic = users[0].picture {
            imageLoader?.downloadImage(urlString: user_pic)
        }

    }
    
    func followLabels() {
        followingTitle.text = "Following"
//        followingLabel.text = String(usersFollowed.count)
        followingLabel.text = "0"
        followingTitle.font = followingTitle.font.withSize(14)
        followingLabel.font = followingLabel.font.withSize(14)
        view.addSubview(followingTitle)
        view.addSubview(followingLabel)
        followLabelContraints()
        
        followingTitle.isHidden = true
        followingLabel.isHidden = true
        
        
        followingLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.followingLabelAction(_:)))
        followingLabel.addGestureRecognizer(gesture)
    }
    
    func usersWhoFollowLabels() {
        followsTitle.text = "Followers"
//        followsLabel.text = String(usersWhoFollow.count)
        followsLabel.text = "0"
        followsTitle.font = followingTitle.font.withSize(14)
        followsLabel.font = followingLabel.font.withSize(14)
        view.addSubview(followsTitle)
        view.addSubview(followsLabel)
        followsTitle.isHidden = true
        followsLabel.isHidden = true
        usersWhoFollowLabelContraints()
        
        followsLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.followsLabelAction(_:)))
        followsLabel.addGestureRecognizer(gesture)
    }
    
    @objc func followingLabelAction(_ sender : UITapGestureRecognizer) {
        if let followUsersVC = followUsersVC {
        navigationController?.pushViewController(followUsersVC, animated: true)
        self.followUsersVC?.followTitle = "Following"
        }
        print("followingLabel clicked")

    }
    
    @objc func followsLabelAction(_ sender : UITapGestureRecognizer) {
        if let usersWhoFollowVC = usersWhoFollowVC {
        navigationController?.pushViewController(usersWhoFollowVC, animated: true)
        self.usersWhoFollowVC?.followTitle = "Followers"
        print("followingLabel clicked")
        }

    }
    
    func followLabelContraints() {
        self.followingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.followingLabel.topAnchor.constraint(equalTo: followingTitle.bottomAnchor).isActive = true
        
        self.followingTitle.translatesAutoresizingMaskIntoConstraints = false
        self.followingTitle.topAnchor.constraint(equalTo: followsLabel.bottomAnchor, constant: 15).isActive = true
        self.followingTitle.centerXAnchor.constraint(equalTo: followsLabel.centerXAnchor).isActive = true
        self.followingLabel.centerXAnchor.constraint(equalTo: followingTitle.centerXAnchor).isActive = true
        
        
        
    }
    
    func usersWhoFollowLabelContraints() {
            self.followsLabel.translatesAutoresizingMaskIntoConstraints = false
            self.followsLabel.topAnchor.constraint(equalTo: followsTitle.bottomAnchor).isActive = true
            
            self.followsTitle.translatesAutoresizingMaskIntoConstraints = false
            self.followsTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
           self.followsTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 13).isActive = true
            self.followsLabel.centerXAnchor.constraint(equalTo: followsTitle.centerXAnchor).isActive = true
        }
           
    func addSpinner() {
          let child = SpinnerViewController()
          addChild(child)
          child.view.frame = view.frame

          view.addSubview(child.view)
          child.didMove(toParent: self)

          self.view.bringSubviewToFront(child.view)

          self.child?.view?.translatesAutoresizingMaskIntoConstraints = false

          self.child?.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

          self.child?.view?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

          self.child?.view?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
          self.child?.view?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
    }
    
    func getAlbum(id: String) {
         GETAlbum(id: id).getPostsById() {
            self.post = $0
    }
    }

    func getArtist(id: String) {
        GetUsersById(id: id).getAllPosts {
            self.users = $0
        }
        
        let getArtistById =  GETArtistById(id: id)
        getArtistById.getAllById {
            self.artistData = $0
       }
        
        GETUsersByFollowerId(id: id).getAllById {
            self.following = $0
        }
        
    }
    
    func getFollowers(id:String) {
        GETFollowersByUserID(id: id).getAllById {
            self.follows = $0
        }
    }
    
    
    
    
    func addTableView() {
        self.myTableView = UITableView()
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.myTableView.dataSource = self
        self.myTableView.delegate = self

        self.view.addSubview(self.myTableView)
        
        print("tbl view")

        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false

        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        self.myTableView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

            myTableView.layoutMargins = UIEdgeInsets.zero
            myTableView.separatorInset = UIEdgeInsets.zero
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(artistData[indexPath.row].title)")
//        getAlbumById(id: artistData[indexPath.row].id!)
        getAlbum(id: artistData[indexPath.row].id!)

        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return " Albums"
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
           cell.textLabel!.text = "playa playa"
           cell.textLabel!.text = "\(artistData[indexPath.row].title!)"
           components.path = "/\(artistData[indexPath.row].path!)"
            self.imageLoader = DownloadImage()
            imageLoader?.imageDidSet = { [weak self] image in
//                    cell.imageView?.image = nil
                self!.imageLoaded = true
                cell.imageView!.image = image
                let itemSize = CGSize.init(width: 100, height: 100)
                            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                            cell.imageView?.image!.draw(in: imageRect)
                            cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                            UIGraphicsEndImageContext();
                cell.layoutIfNeeded()
                cell.setNeedsLayout()
                }
            imageLoader?.downloadImage(urlString: components.url!.absoluteString)
            print("components url \(components.url?.absoluteString)")
    
           if !imageLoaded! {
            cell.imageView!.image = UIImage(named: "music-placeholder")
            let itemSize = CGSize.init(width: 100, height: 100)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
            cell.imageView?.image!.draw(in: imageRect)
            cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
           print("Artist data \(artistData)")
        }
           cell.translatesAutoresizingMaskIntoConstraints = false
           cell.layoutMargins = UIEdgeInsets.zero
           return cell
       }
    
   
}



