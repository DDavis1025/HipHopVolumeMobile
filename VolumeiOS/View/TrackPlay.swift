
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
    static var imgPath:String?
    static var id:String?
    static var author_id:String?
    
    func updatePlaying(newBool: Bool) {
        TrackPlay.self.playing = newBool
    }
    
    func updateViewAppeared(newBool: Bool) {
        TrackPlay.self.viewAppeared = newBool
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
        
//           imageLoader?.imageDidSet = { [weak self ] image in
//            self?.imageView.image = image
//
//          }
           print("TrackPlay.imgPath \(TrackPlay.imgPath)")
//           if let trackPath = TrackPlay.imgPath {
//            components.path = "/\(trackPath)"
//            print("components track url \(components.url!.absoluteString)")
//          }
//          imageLoader?.downloadImage(urlString: components.url!.absoluteString)
        
        
        
//        mySlider?.value = 0.0
//        if let duration = player?.currentItem?.asset.duration {
//        mySlider?.maximumValue = Float(CMTimeGetSeconds(duration))
//        }
//        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
       }
    
    override func viewDidAppear(_ animated: Bool) {
        print("track play appeared")
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
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

