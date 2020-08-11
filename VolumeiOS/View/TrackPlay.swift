
//  TrackPlayVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.


import Foundation
import UIKit
import SwiftUI
import AVFoundation

struct TrackPlay {
    static var playing:Bool? = false
    static var viewAppeared:Bool? = false
    static var trackNameLabel:String?
    static var track:String?
    static var isLiked:Bool?
    static var post_id:String?
    static var imgPath:String?
    static var id:String?
    static var author_id:String?
    
    func updatePlaying(newBool: Bool) {
        TrackPlay.self.playing = newBool
    }
    
    func updateViewAppeared(newBool: Bool) {
        TrackPlay.self.viewAppeared = newBool
    }
    
    func updatePostID(newString:String) {
        TrackPlay.self.post_id = newString
    }
    
    func updateIsLiked(newBool:Bool) {
        TrackPlay.self.isLiked = newBool
    }
    
    func updateTrackNameLabel(newText: String) {
        TrackPlay.self.trackNameLabel = newText
    }
    
    func updateTrackPath(newText: String) {
        TrackPlay.self.track = newText
    }
    
    func updateImgPath(newText: String) {
        TrackPlay.self.imgPath = newText
    }
    
    func updateID(newText: String) {
        TrackPlay.self.id = newText
    }
    
    func updateAuthorID(newString: String) {
        TrackPlay.self.author_id = newString
    }
}

class TrackPlayVC: UIViewController {
    
    var profile = SessionManager.shared.profile
    var post:Post?
    var trackNameLabel:UILabel?
    var playing:Bool?
    var justClicked:Bool? = false
    var mySlider:UISlider?
    var timer: Timer?
    var button:UIButton?
    var imageView = UIImageView()
    var imageLoader:DownloadImage?
    let trackPlay = TrackPlay()
    let album = ModelClass()
    var trackMedia:[MediaPath]?
    var trackName = ""
    var userAndFollow:UserPfAndFollow?
    var commentsBtn:UIButton?
    var likeBtn:UIButton?
    var username:String?
    
    
    let timeRemainingLabel: UILabel = {
         let timeRemaining = UILabel()
         timeRemaining.text = "00:00"
         timeRemaining.textColor = UIColor.black
         return timeRemaining
     }()
     
     let timeElapsedLabel: UILabel = {
         let timeElapsed = UILabel()
         timeElapsed.text = "00:00"
         timeElapsed.textColor = UIColor.black
         return timeElapsed
     }()
    
    lazy var numberOfLikes:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.sizeToFit()
        return label
    }()
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        return component
    }()

    var id:String?
    var author_id:String?
    func captureId(id:String) {
        self.id = id
        trackPlay.updateID(newText: id)
        GETByID(id: id, path: "getTrackAuthor").getById { track in
            if let author_id = track[0].author {
                self.trackPlay.updateAuthorID(newString: author_id)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true
        let dismiss = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissVC))
        dismiss.tintColor = UIColor.black
        
        navigationItem.leftBarButtonItem = dismiss
        print("track view loaded")
        if let author_id = Author.author_id {
         addUserAndFollowView(id: author_id)
        }
        
        if let id = TrackPlay.id {
            GetMedia(id: id, path: "trackAndImage").getMedia {
                self.trackMedia = $0
                self.addTrackImage()
                if let track = self.trackMedia?[0].path {
                   self.components.path = "/\(track)"
                    }
                    if let url = self.components.url?.absoluteString {
                        if self.justClicked! {
                        self.play(url: (NSURL(string: url)!))
                        } else if TrackPlay.playing! {
                            player?.play()
                            print("playing")
                        }
                        self.mySlider?.maximumValue = Float(CMTimeGetSeconds((player?.currentItem?.asset.duration)!))
                        self.timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                }
               }
                
        }
        imageView.image = UIImage(named: "music-placeholder")
        view.addSubview(imageView)
        setImageViewConstraints()
        
         addSlider()
         addLabels()
         view.backgroundColor = UIColor.white
//         play(url: (NSURL(string: (TrackPlay.track!))!))
        if TrackPlay.playing! {
         player?.play()
        }
         addButtons()
         view.addSubview(timeElapsedLabel)
         view.addSubview(timeRemainingLabel)
           if let image = trackMedia?[1].path {
           let imageView = UIHostingController(rootView: ImageView(withURL: image))
           view.addSubview(imageView.view)
           }
         setupConstraints()
        
        getUser()
        addCommentsButton()
        addCommentsBtnConstraints()
        addLikeButton()
        addLikeBtnConstraints()
        postLikeCount()
        
        trackPlay.updateViewAppeared(newBool: true)
        album.updateViewAppeared(newBool: false)
        print("track play view appeared \(TrackPlay.viewAppeared)")
            
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if TrackPlay.playing! {
               button?.setImage(UIImage(named: "pause"), for: .normal)
           } else {
               button?.setImage(UIImage(named: "play"), for: .normal)
           }
        
           if trackName != "" {
             trackPlay.updateTrackNameLabel(newText: trackName)
           }
           if let trackName = TrackPlay.trackNameLabel {
              trackNameLabel!.text = trackName
           }
        

        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
               self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
               self.likeBtn?.tintColor = UIColor.black
               self.trackPlay.updateIsLiked(newBool: false)
       }
    
    override func viewDidAppear(_ animated: Bool) {
        print("track play appeared")
        if let supporter_id = profile?.sub, let post_id = TrackPlay.id {
                 GETLikeRequest(path: "postLikeByUserID", post_id: post_id, supporter_id: supporter_id).getLike {
                     if $0.count > 0 {
                         let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                         self.likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
                         self.likeBtn?.tintColor = UIColor.red
                         self.trackPlay.updateIsLiked(newBool: true)
                     } else {
                         let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                         self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
                         self.likeBtn?.tintColor = UIColor.black
                         self.trackPlay.updateIsLiked(newBool: false)
                     }
                   }
               }
               if let post_id = TrackPlay.id {
                   GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                       self.numberOfLikes.text = "\($0.count)"
                   }
               }
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUser() {
        if let id = profile?.sub {
            print("profile?.sub id \(profile?.sub)")
            GetUsersById(id: id).getAllPosts {
                self.username = $0[0].username
                print("self.username \(self.username)")
            }
        } else {
            print("profile?.sub \(profile?.sub)")
        }
    }
    
    func addUserAndFollowView(id: String) {
        userAndFollow = UserPfAndFollow(id: id)
        if let userAndFollow = userAndFollow {
          addChild(userAndFollow)
          userAndFollow.view.isUserInteractionEnabled = true
          view.addSubview(userAndFollow.view)
          view.bringSubviewToFront(userAndFollow.view)
          
          userAndFollow.didMove(toParent: self)
          self.view.bringSubviewToFront(userAndFollow.view)
          userAndFollow.view.translatesAutoresizingMaskIntoConstraints = false
          userAndFollow.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
          userAndFollow.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
          userAndFollow.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
          userAndFollow.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
          userAndFollow.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
         
    }
    
    
    
    func addLabels() {
        
        trackNameLabel = UILabel()
        
        view.addSubview(trackNameLabel!)
        
        addLabelConstraints()
}
    
    func addLabelConstraints() {
        self.trackNameLabel?.translatesAutoresizingMaskIntoConstraints = false
                                                                     
        trackNameLabel?.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        trackNameLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func addTrackImage() {
        if let track = trackMedia?[1].path {
        components.path = "/\(track)"
        }
        imageLoader = DownloadImage()
        imageLoader?.imageDidSet = { [weak self ] image in
            self?.imageView.image = image
            self?.setImageViewConstraints()
            self?.view.addSubview(self!.imageView)
        }
        imageLoader?.downloadImage(urlString: components.url!.absoluteString)
        
        
    }
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let user_view = userAndFollow?.view {
            imageView.topAnchor.constraint(equalTo: user_view.bottomAnchor, constant: 20).isActive = true
        } else {
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        }

        
        imageView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
}
    
    
    func addSlider() {
            mySlider = UISlider(frame:CGRect(x: 10, y: 100, width: 300, height: 20))
            mySlider?.minimumValue = 0
            mySlider?.isContinuous = true
            mySlider?.tintColor = UIColor.black
            mySlider?.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            mySlider?.thumbTintColor = UIColor.black
               
            self.view.addSubview(mySlider!)

    }
    
    func addButtons() {
        button = UIButton()
//        if playing! {
//            button?.setImage(UIImage(named: "pause"), for: .normal)
//        } else {
//            button?.setImage(UIImage(named: "play"), for: .normal)
//        }
        button?.imageView?.contentMode = .scaleAspectFit
        button?.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        
        view.addSubview(button!)
    }
    
    @objc func buttonClicked(_: UIButton) {
        guard let player = player else { return }
        if TrackPlay.playing! {
            player.pause()
            button?.setImage(UIImage(named: "play"), for: .normal)
            trackPlay.updatePlaying(newBool: false)
        } else {
            player.play()
            trackPlay.updatePlaying(newBool: true)
            button?.setImage(UIImage(named: "pause"), for: .normal)
        }
    }

    

    
    func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return ""
        }
        return "\(minsStr):\(secsStr)"
    }
    
    @objc func updateSlider() {
        guard let player = player else { return }
        mySlider?.value = Float(CMTimeGetSeconds(player.currentTime()))
        let remainingTimeInSeconds = CMTimeGetSeconds((player.currentItem?.asset.duration)!) - CMTimeGetSeconds(player.currentTime())
                 
        timeRemainingLabel.text = getFormattedTime(timeInterval: remainingTimeInSeconds)
        timeElapsedLabel.text = getFormattedTime(timeInterval: CMTimeGetSeconds(player.currentTime()))

    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        guard let player = player else { return }
        if let duration = player.currentItem?.duration {
            _ = CMTimeGetSeconds(duration)
            let value = Float64(mySlider!.value)
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player.seek(to: seekTime)
        }

    }
    
    
    func play(url:NSURL)  {
               do {
                   try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                   try AVAudioSession.sharedInstance().setActive(true)

                try player = AVPlayer(url: url as URL)
                
                print("URL \(url)")
                
                player?.play()
                trackPlay.updatePlaying(newBool: true)
                mySlider?.value = 0.0
                if let duration = player?.currentItem?.asset.duration {
                    mySlider?.maximumValue = Float(CMTimeGetSeconds(duration))
                }
                timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)

                button?.setImage(UIImage(named: "pause"), for: .normal)
               } catch let error {
                   print(error.localizedDescription)
               }
               
//               return player
    }
    
    func setupConstraints() {
        self.timeRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeElapsedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mySlider?.translatesAutoresizingMaskIntoConstraints = false
        self.button?.translatesAutoresizingMaskIntoConstraints = false
                                                              
        timeElapsedLabel.leadingAnchor.constraint(equalTo: self.mySlider!.leadingAnchor).isActive = true

        timeRemainingLabel.trailingAnchor.constraint(equalTo: self.mySlider!.trailingAnchor).isActive = true
        
        timeElapsedLabel.topAnchor.constraint(equalTo: self.mySlider!.bottomAnchor).isActive = true
        timeRemainingLabel.topAnchor.constraint(equalTo: self.mySlider!.bottomAnchor).isActive = true
        
        mySlider?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        mySlider?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        mySlider?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        mySlider?.topAnchor.constraint(equalTo: (self.trackNameLabel?.bottomAnchor)!, constant: 20).isActive = true
        
        button?.centerXAnchor.constraint(equalTo: self.mySlider!.centerXAnchor).isActive = true
        
        button?.topAnchor.constraint(equalTo: self.timeElapsedLabel.bottomAnchor, constant: 20).isActive = true
        
        button?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        button?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    
    
    }
        
}


extension TrackPlayVC {
    
    func addCommentsButton() {
        print("add Comments to track play vc")
        let commentsBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        commentsBtn = UIButton()
        commentsBtn?.setImage(UIImage(systemName: "message", withConfiguration: commentsBtnConfig), for: .normal)
        commentsBtn?.addTarget(self, action: #selector(commentsBtnClicked(_:)), for: .touchUpInside)
        commentsBtn?.tintColor = UIColor.black
        if let commentsBtn = commentsBtn {
        view.addSubview(commentsBtn)
        }
    }
    
    func addCommentsBtnConstraints() {
        commentsBtn?.translatesAutoresizingMaskIntoConstraints = false
        commentsBtn?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        commentsBtn?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
    }
    
    @objc func commentsBtnClicked(_ sender: UIButton) {
        let commentVC = CommentVC()
        commentVC.post_id = TrackPlay.id
        let commentVC2 = UINavigationController(rootViewController: commentVC)
        commentVC2.modalPresentationStyle = .popover
        self.present(commentVC2, animated: true, completion: nil)
    }
    
}


extension TrackPlayVC {
    
    func addLikeButton() {
        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        likeBtn = UIButton()
        likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
        likeBtn?.addTarget(self, action: #selector(likeBtnClicked(_:)), for: .touchUpInside)
        likeBtn?.tintColor = UIColor.black
        if let likeBtn = likeBtn {
        view.addSubview(likeBtn)
        }
    }
    
    func addLikeBtnConstraints() {
        likeBtn?.translatesAutoresizingMaskIntoConstraints = false
        guard let commentsBtn = commentsBtn else {
            return
        }
        likeBtn?.centerYAnchor.constraint(equalTo: commentsBtn.centerYAnchor).isActive = true
        
        likeBtn?.centerXAnchor.constraint(equalTo: commentsBtn.centerXAnchor, constant: -80).isActive = true
    }
    
    func postLikeCount() {
        guard let likeBtn = likeBtn else {
            return
        }
        view.addSubview(numberOfLikes)
        numberOfLikes.translatesAutoresizingMaskIntoConstraints = false
        numberOfLikes.centerXAnchor.constraint(equalTo: likeBtn.centerXAnchor).isActive = true
        numberOfLikes.bottomAnchor.constraint(equalTo: likeBtn.topAnchor, constant: -5).isActive = true
    }
    
    @objc func likeBtnClicked(_ sender: UIButton) {
            if TrackPlay.isLiked == true {
            let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
            likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
            likeBtn?.tintColor = UIColor.black
                if let supporter_id = profile?.sub, let post_id = TrackPlay.id {
                let deleteRequest = DLTLike(post_id: post_id, supporter_id: supporter_id)
                
                deleteRequest.delete {(err) in
                    if let err = err {
                        print("Failed to delete", err)
                        return
                    }
                    
                    if let post_id = TrackPlay.id {
                        GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                            self.numberOfLikes.text = "\($0.count)"
                        }
                    }
                    
                    print("Successfully deleted post like from server")
                }
            }
            trackPlay.updateIsLiked(newBool: false)
        } else {
            print("liked post")
            let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold, scale: .medium)
            likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
            likeBtn?.tintColor = UIColor.red
                if let supporter_id = profile?.sub, let supporter_username = self.username, let supporter_picture = profile?.picture, let post_id = TrackPlay.id, let user_id = TrackPlay.author_id {
                    let postLike = LikeModel(user_id: user_id, supporter_id: supporter_id, supporter_username: supporter_username, supporter_picture: supporter_picture.absoluteString, post_id: post_id)
            
            
            let postRequest = LikeRequest(endpoint: "postLike")
            postRequest.save(postLike) { (result) in
                switch result {
                case .success(let comment):
                    print("success: you liked a post")
                    if let post_id = TrackPlay.id {
                        GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                            self.numberOfLikes.text = "\($0.count)"
                        }
                    }
                case .failure(let error):
                    print("An error occurred while liking post: \(error)")
                }
            }
          }
           trackPlay.updateIsLiked(newBool: true)
      }
    }
    
}

