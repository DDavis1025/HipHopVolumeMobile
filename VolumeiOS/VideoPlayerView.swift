//
//  VideoPlayerView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/2/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    private var playerLayer: AVPlayerLayer?
    var player:AVPlayer?
    var isPlaying = false
    var videoURL:String?
    var secondToFadeOut = 5 // How many second do you want the view to idle before the button fades. You can change this to whatever you'd like.
    var timer:Timer = Timer() // Create the timer!
    var isTimerRunning:Bool = false // Need this to prevent multiple timers from running at the same time.
    
    func addVideoURL(video: String) {
        videoURL = video
        setupPlayer()
        playerLayer?.frame = bounds
        bringSubviewToFront(controlsContainerView)
        print("video URL \(videoURL)")
    }
    
    let activityIndicatorView:UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = UIColor.white
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .black, scale: .medium)
        let image = UIImage(systemName: "pause.fill", withConfiguration: config) as UIImage?
        let whiteImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(whiteImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause(_:)), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc func handlePause(_ sender: UIButton!) {
        print("pause clicked")
        if isPlaying {
            player?.pause()
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .medium)
            let play = UIImage(systemName: "play.fill", withConfiguration: config) as UIImage?
            let playImage = play?.withTintColor(.white, renderingMode: .alwaysOriginal)
            pausePlayButton.setImage(playImage, for: .normal)
        } else {
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .black, scale: .medium)
            let image = UIImage(systemName: "pause.fill", withConfiguration: config) as UIImage?
            let whiteImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
            pausePlayButton.setImage(whiteImage, for: .normal)
            player?.play()
        }
        
        isPlaying = !isPlaying
    }
    
    
    let videoLengthLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.darkGray
        slider.maximumTrackTintColor = UIColor.white
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .black, scale: .medium)
        let thumb = UIImage(systemName: "circle.fill", withConfiguration: config) as UIImage?
        let thumbImage = thumb?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        slider.setThumbImage(thumbImage, for: .normal)
        
        slider.addTarget(self,
                         action: #selector(handleSliderChange),
                         for: .valueChanged)
        
        slider.addTarget(self,
                         action: #selector(mySliderBeganTracking),
                         for:.touchDown)

        slider.addTarget(self,
                         action: #selector(mySliderEndedTracking),
                         for: .touchUpInside)
        
        slider.addTarget(self,
                         action: #selector(mySliderEndedTrackingOut),
                         for: .touchUpOutside )
        
        return slider
    }()
    
    @objc func mySliderBeganTracking() {
        player?.pause()
    }
    
    @objc func mySliderEndedTracking() {
        if isPlaying {
        player?.play()
        }
    }
    
    @objc func mySliderEndedTrackingOut() {
        if isPlaying {
        player?.play()
        }
    }
    
    
    
    @objc func handleSliderChange() {
    
         if let duration = player?.currentItem?.duration{

           let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            print("totalSeconds \(totalSeconds)")
            print("videoSlider.value \(videoSlider.value)")
            print("value \(value)")
            let seekTime = CMTime(seconds: Double(value) , preferredTimescale: 600)
            player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (completedSeek) in
            })
        }
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.addGestureRecognizer(tapRecognizer)
        
        
        addSubview(controlsContainerView)
        
        
        
        NSLayoutConstraint.activate([
          controlsContainerView.topAnchor.constraint(equalTo: topAnchor),
          controlsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
          controlsContainerView.leftAnchor.constraint(equalTo: leftAnchor),
          controlsContainerView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        controlsContainerView.addSubview(activityIndicatorView)
        
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: controlsContainerView.rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: controlsContainerView.leftAnchor, constant: -8).isActive = true
        currentTimeLabel.centerYAnchor.constraint(equalTo: videoLengthLabel.centerYAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: -10).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 10).isActive = true
        videoSlider.centerYAnchor.constraint(equalTo: videoLengthLabel.centerYAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        backgroundColor = UIColor.black
    }
    
    func runTimer() {
        // Create the timer to run a method (in this case... updateTimer) every 1 second.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        // Set the isTimerRunning bool to true
        isTimerRunning = true
    }
    
    
    @objc func updateTimer() {
        // Every 1 second that this method runs, 1 second will be chopped off the secondToFadeOut property. If that hits 0 (< 1), then run the fadeOutButton and invalidate the timer so it stops running.
        secondToFadeOut -= 1
        print(secondToFadeOut)
        if secondToFadeOut < 1 {
            fadeOutButton()
            timer.invalidate()
            isTimerRunning = false
        }
    }
    
    func fadeOutButton() {
        // Fade out your button! I also disabled it here. But you can do whatever your little heart desires.
        UIView.animate(withDuration: 0.5) {
            self.pausePlayButton.alpha = 0.25
        }
        self.pausePlayButton.isEnabled = false
        self.pausePlayButton.isHidden = true
    }
    
    func fadeInButton() {
        // Fade the button back in, and set it back to active (so it's tappable)
        UIView.animate(withDuration: 0.5) {
            self.pausePlayButton.alpha = 1
        }
        self.pausePlayButton.isEnabled = true
        self.pausePlayButton.isHidden = false
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        // When the view is tapped (based on the gesture recognizer), reset the secondToFadeOut property, fade in (and enable) the button.
        secondToFadeOut = 5
        fadeInButton()
        timer.invalidate()
        if isTimerRunning == false {
            runTimer()
        }
    }

    
    private func setupPlayer() {
        print("videoURL \(videoURL)")
        let urlString = videoURL
        if let urlString = urlString {
        if let url = URL(string: urlString) {
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspect
        
        self.layer.addSublayer(playerLayer)
        
        self.playerLayer = playerLayer
        player?.play()
        
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        //track player progress
       let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let minutsString = String(format: "%02d", Int(seconds/60))
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            self.currentTimeLabel.text = "\(minutsString):\(secondsString)"
            
            if let duration = self.player?.currentItem?.duration{
                let durationSeconds = CMTimeGetSeconds(duration)
                self.videoSlider.value = Float(seconds / durationSeconds)
            }
        })
      }
    }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            
            if let duration = player?.currentItem?.duration{
                let seconds = CMTimeGetSeconds(duration)
                let minutsText = String(format: "%02d", Int(seconds)/60)
                let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                videoLengthLabel.text = "\(minutsText):\(secondsText)"
            }
            }
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}


class VideoVC: UIViewController {
    var id:String = ""
    var path:String?
    init(id:String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var playerView: VideoPlayerView = {
        let playerView = VideoPlayerView(frame: .zero)
        playerView.backgroundColor = .black
        
        return playerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        GetMedia(id: id, path: "video_path").getMedia {
            self.path = $0[0].path!
            print("video path \(self.path)")
            var components = URLComponents()
            components.scheme = "http"
            components.host = "localhost"
            components.port = 8000
            if let path = self.path {
            components.path = "/\(path)"
            if let url = components.url?.absoluteString {
              print("url \(url)")
              self.playerView.addVideoURL(video: url)
            }
            }
        }
        view.addSubview(playerView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = view.safeAreaLayoutGuide.layoutFrame.size.width / 1.777777777777778
        playerView.frame = CGRect(x: view.safeAreaLayoutGuide.layoutFrame.origin.x, y: view.safeAreaLayoutGuide.layoutFrame.origin.y, width: view.safeAreaLayoutGuide.layoutFrame.size.width, height: height)
    }
}
