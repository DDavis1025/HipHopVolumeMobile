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
    var post:Post? {
        didSet {
            let vc = AlbumVC(post: self.post!)
            self.navigationController?.pushViewController(vc, animated: true)
            print("posty \(post)")
        }
    }
    var label:UILabel? = nil
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
    var artistData = [ArtistModel]() {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
                print("Artist Data \(self.artistData)")
                self.isLoaded = true
                self.albumImages()
                self.child?.willMove(toParent: nil)
                self.child?.view.removeFromSuperview()
                self.child?.removeFromParent()

            }
        }
    }
    var posts:Array<Any> = []
    var artistID:String?
    
    static var shared = ArtistProfileVC()
    
    
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        
        return component
    }()
    
//    func prepareForReuse() {
//        imageView?.image = nil
//    }

        override func viewDidLoad() {
            super.viewDidLoad()
            addSpinner()
            addTableView()

            addImagePH()
    
            getArtist(id: artistID!)
            
//            self.view.layoutIfNeeded()
//            self.view.setNeedsLayout()
            
            view.backgroundColor = UIColor.white
            
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
            label?.text = "\(self.users[0].name!)"

            imageLoader = DownloadImage()
                self.imageLoader?.imageDidSet = { [weak self] image in
                self?.imageView.image = image
                self?.view?.addSubview(self!.imageView)
                self?.setImageContraints()
                }
            imageLoader?.downloadImage(urlString: users[0].picture!)

    }
           
    func addSpinner() {
          let child = SpinnerViewController()
          addChild(child)
          child.view.frame = view.frame
//          child.view.backgroundColor = UIColor.white
          view.addSubview(child.view)
          child.didMove(toParent: self)
//          child.view.backgroundColor = UIColor.black
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
        
        print("users \(self.users)")
        
        _ = ArtistProfileVC()
        let getArtistById =  GETArtistById(id: id)
        getArtistById.getAllById {
            self.artistData = $0
       }
    }
    
    
   func albumImages() {
       for artist in self.artistData {
//           imageLoader = DownloadImage(urlString: String(self.components.url!.absoluteString + "/\(artist.path!)"))
//            self.imageLoader?.imageDidSet = { [weak self] image in
//            let image = image
////            self?.images?.append(image!)
//         }
            
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

//        self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
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
//           imageLoader = DownloadImage(urlString: String(self.components.url!.absoluteString))
//           self.imageLoader?.imageDidSet = { [weak self] image in
//            cell.imageView!.image = self?.imageLoader?.image
//            let itemSize = CGSize.init(width: 100, height: 100)
//            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
//            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
//            cell.imageView?.image!.draw(in: imageRect)
//            cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
//            UIGraphicsEndImageContext();
//           }
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
//            imageLoader?.downloadImage(urlString: components.url!.absoluteString)
    

//
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
//
           cell.translatesAutoresizingMaskIntoConstraints = false
           cell.layoutMargins = UIEdgeInsets.zero
//        }
           return cell
       }
    
   
}



