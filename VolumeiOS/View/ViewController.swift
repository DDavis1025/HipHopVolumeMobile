//
//  ViewController.swift
//  Test
//
//  Created by Dillon Davis on 3/27/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

import UIKit
import SwiftUI
import AVFoundation

class ViewController: Toolbar, UITableViewDelegate, UITableViewDataSource {
    
    private var myTableView: UITableView!
    var listArray:[PostById] = []
    var songArray:Array<Any> = []
    var songPath:Array<Any> = []
    var songId:Array<String> = []
    var albumId:Array<Any> = []
    let post:Post
    var otherSong:String?
    var trackPath:[String]?
    var components:URLComponents = {
           var component = URLComponents()
           component.scheme = "http"
           component.host = "localhost"
           component.port = 8000
           return component
       }()
    
    var albumData = [PostById]() {
        didSet {
            DispatchQueue.main.async {
            print("album data \(self.albumData)")
                self.trackPaths()
                let imagePath = self.albumData.filter { i in i.id == self.post.id
                }
                
                
                self.listArray = self.albumData.filter { i in i.album_id == self.post.id && i.id != self.post.id
                }

                self.components.path = "/\(self.albumData[0].path)"

                self.modelClass.updateImgPath(newText: self.components.url!.absoluteString)
                
                self.myTableView?.reloadData()
            }
        }
    }
    
    var playing:Bool?
    
    var indexPath:String?
    
    var navBar:UINavigationBar?
    
    var albumTrackBtnClicked:Bool? = false
    
    
    
//    var button:UIButton?
    
    
    
    let trackVC = AlbumTrackVC()
    let modelClass = ModelClass()

    
    init(post: Post){
    self.post = post
    modelClass.updatePost(newPost: post)
    trackVC.post = post
    
    print("model class post \(ModelClass.post?.title)")

   
    
//    let imagePath = ContentView.shared.mainArray.filter { i in i.id == post.id
//      }
//        let imagePath = albumData.filter { i in i.id == post.id
//        }
//
//        for post in imagePath {
//            modelClass.updateImgPath(newText: post.path)
//        }
    
//    listArray = albumData.filter { i in i.album_id == post.id && i.id != post.id
//    }
        
        print("list Array \(listArray)")
        
        for post in listArray {
            songArray.append(post.name ?? "unAvailable")
            components.path =  "/\(post.path)"
            songPath.append(components.url?.absoluteString)
            songId.append(post.id)
            albumId.append(post.album_id)
        }
        
//        images = self.albumData.map { path in
//            components.path = path.path
//            return components.url!.absoluteString
//         }
//
        
//    trackVC.albumId = albumId
        
    super.init(nibName: nil, bundle: nil)
        
        getAlbumById(id: post.id!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        

        modelClass.updateTheViewLoaded(newBool: true)
//        button = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 50))
//
//               button?.setImage(UIImage(named: "play"), for: .normal)
//               button?.imageView?.contentMode = .scaleAspectFit
//               button?.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
//
        
        view.backgroundColor = UIColor.darkGray

        addTableView()
        addingNavBar()

        
        view.isUserInteractionEnabled = true
//        view.addSubview(button!)

//

    }
    
//    @objc func buttonClicked(_: UIButton) {
//        let mainVC = ViewController(post:post)
//        self.navigationController?.pushViewController(mainVC, animated: true)
//    }
    
    func albumTrackPush() {
           let mainVC = ViewController(post:post)
           self.navigationController?.pushViewController(mainVC, animated: true)
       }
    

    
    func addingNavBar() {
    DispatchQueue.main.async {
        if self.albumTrackBtnClicked! {
             print("addingNB Clicked!")
                
            self.navBar = UINavigationBar()
            self.navBar?.frame.size.width = self.view.frame.size.width
            self.navBar?.frame.size.height = 204
                    
            let navItem = UINavigationItem(title: self.post.title!)
                    let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
                    let image = UIImage(systemName: "chevron.left", withConfiguration: symbolConfig)

            
                        let doneItem = UIBarButtonItem(
                            image: image,
                            style: .plain,
                            target: self,
                            action: #selector(self.selectorName(sender:))
                        )
          doneItem.tintColor = UIColor.black
                    
           navItem.leftBarButtonItem = doneItem
          self.navBar?.barTintColor = UIColor.lightGray
        
           self.navBar!.setItems([navItem], animated: false)
                
           self.view.addSubview(self.navBar!)
        
          self.navBar?.translatesAutoresizingMaskIntoConstraints = false
            
            self.navBar?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        
            self.navBar?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

            self.navBar?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

                      self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
            
            self.myTableView?.topAnchor.constraint(equalTo: self.navBar!.bottomAnchor).isActive = true
                 
    
                
         }
        }
    }

    func getAlbumById(id: String) {
        SecondWebService(id: id).getAllPostsById {
            self.albumData = $0
        }
    }
    
    func trackPaths() {
        trackPath = self.albumData.map { path in
            components.path = "/\(path.path)"
            return components.url!.absoluteString
         }
        trackPath?.removeFirst()
        print("track path \(trackPath)")
        
    }
    
    
    func addTableView() {
        
            self.myTableView = UITableView()
                    
                    
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
                            
            self.myTableView.frame.size.height = self.view.frame.height
        //
            self.myTableView.frame.size.width = self.view.frame.width
                    
                            
            self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                            self.myTableView.dataSource = self
                            self.myTableView.delegate = self
                            self.myTableView.isScrollEnabled = true
                    
            myTableView.delaysContentTouches = false
            self.view.addSubview(self.myTableView)
                    
            if self.albumTrackBtnClicked! {
                print("yo yo yo")
                self.addingNavBar() } else {
            self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            }
            self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

            self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

            self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
            myTableView.layoutMargins = UIEdgeInsets.zero
            myTableView.separatorInset = UIEdgeInsets.zero
            
                    
                    

       

    }
    
    
//    private func setupLayout() {
//        view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//         view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//         view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//
//    }
//
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        trackVC.trackNameLabel?.text = "\(listArray[indexPath.row].name!)"
//        trackVC.track = songPath[indexPath.row] as? String
        modelClass.updateTrackNameLabel(newText: "\(listArray[indexPath.row].name!)")
        print("tdsr \(ModelClass.trackNameLabel)")
//        print("TracknameLAbel MC \(modelClass.trackNameLabel)")
        modelClass.updateTrackPath(newText: (trackPath?[indexPath.row])!)
//        ModelClass.track =
//        print("model class track \(ModelClass.track)")
        
//        AlbumTrackVC.shared.trackNameLabel.text = "\(songArray[indexPath.row])"
//        AlbumTrackVC.shared.track = songPath[indexPath.row] as? String
        if !albumTrackBtnClicked! {
        self.present(trackVC, animated: true, completion: nil)
        } else {
            trackVC.play(url: (NSURL(string: (ModelClass.track!))!))
        }
        
         
        
//        print("Song \(songPath[indexPath.row])")
//        print("Num: \(indexPath.row)")
//        print("Value: \(songArray[indexPath.row])")
//        trackVC.listArray = listArray
         modelClass.updateListArray(newList: listArray)
//         ModelClass.listArray = listArray
//        AlbumTrackVC.shared.listArray = listArray
        let index = indexPath.row
//        trackVC.index = index
        modelClass.updateIndex(newInt: index)
        modelClass.updatePlaying(newBool: true)
        trackVC.justClicked = true
        print("playing \(trackVC.playing)")
//         ModelClass.index = index
//        index = self.index
//        AlbumTrackVC.shared.index = index
//        let mainVC = OtherView()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(listArray[indexPath.row].name!)"
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " Tracks"
    }

   
    
    @objc func selectorName(sender: UINavigationItem) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
//        albumTrackBtnClicked = false
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
       }
    
    
}

struct IntegratedController: UIViewControllerRepresentable {
    var post:Post
    func makeUIViewController(context: UIViewControllerRepresentableContext<IntegratedController>) -> ViewController {
        return ViewController(post: post)
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<IntegratedController>) {

    }
    
    
}


