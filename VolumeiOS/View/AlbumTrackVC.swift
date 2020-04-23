//
//  AlbumTrackVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation

var player:AVPlayer?
class AlbumTrackVC: Toolbar {

    var post:Post?
    var albumNameLabel:UILabel?
    var trackNameLabel:UILabel?
    var playing:Bool?
    var justClicked:Bool? = false
    var mySlider:UISlider?
    var timer: Timer?
    var button:UIButton?
    var goBackBtn:UIButton?
    var goForwardBtn:UIButton?
    var imageView:UIViewController?
    var albumTracksBtn:UIButton?
    
    let modelClass = ModelClass()
    
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
         imageViewVC()
         addSlider()
         addLabels()
         print("MCp \(ModelClass.post)")
         view.backgroundColor = UIColor.white
//         play(url: (NSURL(string: (ModelClass.track!))!))
        if ModelClass.playing! {
         player?.play()
        }
         print("model class track \(ModelClass.track)")
         addButtons()
         view.addSubview(timeElapsedLabel)
         view.addSubview(timeRemainingLabel)
         if let image = ModelClass.imgPath {
           let imageView = UIHostingController(rootView: ImageView(withURL: image))
           view.addSubview(imageView.view)
           }
         setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if ModelClass.playing! {
               button?.setImage(UIImage(named: "pause"), for: .normal)
           } else {
               button?.setImage(UIImage(named: "play"), for: .normal)
           }
           trackNameLabel!.text = ModelClass.trackNameLabel
        
        print(ModelClass.justClicked)
        
        if ModelClass.justClicked! && !ModelClass.clickedFromAT! {
           play(url: (NSURL(string: (ModelClass.track!))!))
           modelClass.updateJustClicked(newBool: false)
        }
        mySlider?.value = 0.0
        mySlider?.maximumValue = Float(CMTimeGetSeconds((player?.currentItem?.asset.duration)!))
        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
       }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        guard let player = player else { return }
//        print("justClicked \(justClicked)")
//        if ModelClass.justClicked! {
//           play(url: (NSURL(string: (ModelClass.track!))!))
//           modelClass.updateJustClicked(newBool: false)
//        }
//        mySlider?.value = 0.0
//        mySlider?.maximumValue = Float(CMTimeGetSeconds((player.currentItem?.asset.duration)!))
//        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
//
//
//    }
    
    
    func addLabels() {
        albumNameLabel = UILabel()
        
        albumNameLabel!.text = ModelClass.post?.title
        
        trackNameLabel = UILabel()
        
        view.addSubview(albumNameLabel!)
        view.addSubview(trackNameLabel!)
        
        addLabelConstraints()
}
    
    func addLabelConstraints() {
        self.albumNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.trackNameLabel?.translatesAutoresizingMaskIntoConstraints = false
                                                                     
//        albumNameLabel?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        albumNameLabel?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        albumNameLabel?.topAnchor.constraint(equalTo: imageView!.view.bottomAnchor, constant: 20).isActive = true
        
//        trackNameLabel?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        trackNameLabel?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackNameLabel?.topAnchor.constraint(equalTo: albumNameLabel!.bottomAnchor, constant: 20).isActive = true
        
        albumNameLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        trackNameLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func imageViewVC() {
        print("image view vc")
        components.path = "/\(ModelClass.post!.path)"
        imageView = UIHostingController(rootView: ImageView(withURL: components.url!.absoluteString))
        print("url components \(components.url)")
        addChild(imageView!)
        view.addSubview(imageView!.view)
        imageView?.didMove(toParent: self)
        setImageViewVCConstraints()
    }
    
    func setImageViewVCConstraints() {
        imageView?.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        imageView?.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        
        imageView?.view.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        imageView?.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        imageView?.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
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
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold, scale: .medium)
        goBackBtn = UIButton()
        goForwardBtn = UIButton()
        goBackBtn?.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: symbolConfig), for: .normal)
        goBackBtn?.addTarget(self, action: #selector(goBackBtnClicked(_:)), for: .touchUpInside)
        goForwardBtn?.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: symbolConfig), for: .normal)
        goForwardBtn?.addTarget(self, action: #selector(goForwardBtnClicked(_:)), for: .touchUpInside)
        goBackBtn?.tintColor = UIColor.black
        goForwardBtn?.tintColor = UIColor.black
        
        let albumTracksBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold, scale: .medium)
        albumTracksBtn = UIButton()
        albumTracksBtn?.setImage(UIImage(systemName: "music.note.list", withConfiguration: albumTracksBtnConfig), for: .normal)
        albumTracksBtn?.addTarget(self, action: #selector(albumTracksBtnClicked(_:)), for: .touchUpInside)
        albumTracksBtn?.tintColor = UIColor.black
        
        view.addSubview(button!)
        view.addSubview(goBackBtn!)
        view.addSubview(goForwardBtn!)
        view.addSubview(albumTracksBtn!)
    }
    
    @objc func buttonClicked(_: UIButton) {
        guard let player = player else { return }
        if ModelClass.playing! {
            player.pause()
            button?.setImage(UIImage(named: "play"), for: .normal)
            modelClass.updatePlaying(newBool: false)
        } else {
            player.play()
            modelClass.updatePlaying(newBool: true)
            button?.setImage(UIImage(named: "pause"), for: .normal)
        }
    }

    @objc func goBackBtnClicked(_: UIButton) {
        var index = ModelClass.index
        print("index go back \(index)")
        if index! > 0 {
        index! -= 1
        modelClass.updateIndex(newInt: index!)
        trackNameLabel?.text = ModelClass.listArray![index!].name
        components.path =  "/\(ModelClass.listArray![index!].path)"
        play(url: components.url! as NSURL)
        print("url gb \(components.url! as NSURL)")
        }
        
       }
    
    @objc func goForwardBtnClicked(_: UIButton) {
        var index = ModelClass.index
        if index! < ModelClass.listArray!.count - 1 {
        index! += 1
        modelClass.updateIndex(newInt: index!)
        print("index \(index)")
        trackNameLabel?.text = ModelClass.listArray![index!].name
        components.path =  "/\(ModelClass.listArray![index!].path)"
        play(url: components.url! as NSURL)
        print("url gf \(components.url! as NSURL)")
        }
    }
    
    @objc func albumTracksBtnClicked(_: UIButton) {
        let vc = ViewController(post: ModelClass.post!)
        vc.albumTrackBtnClicked = true
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
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
                modelClass.updatePlaying(newBool: true)

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
        self.goBackBtn?.translatesAutoresizingMaskIntoConstraints = false
        self.goForwardBtn?.translatesAutoresizingMaskIntoConstraints = false
        self.albumTracksBtn?.translatesAutoresizingMaskIntoConstraints = false
                                                              
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
        
        goBackBtn?.leadingAnchor.constraint(equalTo: self.button!.leadingAnchor, constant: -60).isActive = true

        goForwardBtn?.trailingAnchor.constraint(equalTo: self.button!.trailingAnchor, constant: 60).isActive = true
        
        goForwardBtn?.centerYAnchor.constraint(equalTo: self.button!.centerYAnchor).isActive = true

        goBackBtn?.centerYAnchor.constraint(equalTo: self.button!.centerYAnchor).isActive = true
        
        albumTracksBtn?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        albumTracksBtn?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
    
    
    }
        
}
