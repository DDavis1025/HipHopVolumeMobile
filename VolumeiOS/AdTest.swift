//
//  AdTest.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/21/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import AVFoundation

class AdMobView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(adMobMediaView)
        addSubview(headlineView)
        addSubview(advertiserView)
        addSubview(bodyLabel)
        addSubview(bodyView)
        addSubview(storeView)
        addSubview(priceView)
        addSubview(iconView)
        addSubview(starRatingView)
        addSubview(callToActionBtn)
        addSubview(adLabel)
        addSubview(adChoicesImage)
        adMobMediaViewConstraints()
        iconViewConstraints()
        headlineViewConstraints()
        advertiserViewConstraints()
        starRatingViewConstraints()
        bodyViewConstraints()
        callToActionBtnConstraints()
        storeViewConstraints()
        priceViewConstraints()
        adLabelConstraints()
        adChoicesLogoConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let adMobMediaView: GADMediaView = {
           let mediaView = GADMediaView()
           mediaView.translatesAutoresizingMaskIntoConstraints = false
           return mediaView
       }()
    
    var adLabel:UILabel = {
        let label = UILabel()
        label.text = "Ad"
        label.backgroundColor = UIColor.yellow
        label.textAlignment = .center
        return label
    }()
    
    var headlineView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    var advertiserView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    var bodyLabel:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    lazy var bodyView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.sizeToFit()
        tv.backgroundColor = UIColor.gray
        tv.textContainer.maximumNumberOfLines = 4
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.font = UIFont(name: "GillSans", size: 18)
        return tv
    }()
    
    var storeView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    var priceView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    lazy var adChoicesImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GoogleAdChoicesIcon")
        return imageView
    }()
    
    lazy var iconView:UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var starRatingView:UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var callToActionBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    func adMobMediaViewConstraints() {
        adMobMediaView.translatesAutoresizingMaskIntoConstraints = false
        adMobMediaView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        adMobMediaView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        adMobMediaView.topAnchor.constraint(equalTo: bodyView.bottomAnchor).isActive = true
    }
    
    func adLabelConstraints() {
        adLabel.translatesAutoresizingMaskIntoConstraints = false
        adLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        adLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        adLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        adLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
    }
    
    func adChoicesLogoConstraints() {
        adChoicesImage.translatesAutoresizingMaskIntoConstraints = false
        adChoicesImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        adChoicesImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        adChoicesImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        adChoicesImage.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
    }
    
    func iconViewConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        iconView.topAnchor.constraint(equalTo: adLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func headlineViewConstraints() {
        headlineView.translatesAutoresizingMaskIntoConstraints = false
        headlineView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10).isActive = true
        headlineView.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
    }
    
    func advertiserViewConstraints() {
        advertiserView.translatesAutoresizingMaskIntoConstraints = false
        advertiserView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10).isActive = true
        advertiserView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: -30).isActive = true
    }
    
    func starRatingViewConstraints() {
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        starRatingView.leadingAnchor.constraint(equalTo: advertiserView.trailingAnchor).isActive = true
        starRatingView.centerYAnchor.constraint(equalTo: advertiserView.centerYAnchor).isActive = true
    }
    
    func bodyViewConstraints() {
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor).isActive = true
        bodyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        bodyView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10).isActive = true
    }
    
    func callToActionBtnConstraints() {
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        callToActionBtn.topAnchor.constraint(equalTo: adMobMediaView.bottomAnchor).isActive = true
    }
    
    func storeViewConstraints() {
        storeView.translatesAutoresizingMaskIntoConstraints = false
        storeView.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: 5).isActive = true
        storeView.centerYAnchor.constraint(equalTo: callToActionBtn.centerYAnchor).isActive = true
    }
    
    func priceViewConstraints() {
        priceView.translatesAutoresizingMaskIntoConstraints = false
        priceView.trailingAnchor.constraint(equalTo: storeView.leadingAnchor, constant: 5).isActive = true
        priceView.centerYAnchor.constraint(equalTo: callToActionBtn.centerYAnchor).isActive = true
    }
    
    
    
}


class AdTest: UIViewController, GADUnifiedNativeAdLoaderDelegate {
    
    var adMobView:AdMobView?
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        adMobView = AdMobView()
        adMobView?.adMobMediaView.mediaContent = nativeAd.mediaContent
//        adMobView?.adMobMediaView.isHidden = nativeAd.mediaContent == nil
        adMobView?.iconView.image = nativeAd.icon?.image
        adMobView?.iconView.isHidden = nativeAd.icon == nil
        adMobView?.headlineView.text = nativeAd.headline
        adMobView?.headlineView.isHidden = nativeAd.headline == nil
        adMobView?.bodyLabel.text = nativeAd.body
        adMobView?.bodyLabel.isHidden = nativeAd.body == nil
        adMobView?.storeView.text = nativeAd.store
        adMobView?.storeView.isHidden = nativeAd.store == nil
        adMobView?.priceView.text = nativeAd.price
        adMobView?.priceView.isHidden = nativeAd.price == nil
        adMobView?.advertiserView.text = nativeAd.advertiser
        adMobView?.advertiserView.isHidden = nativeAd.advertiser == nil
        adMobView?.callToActionBtn.setTitle(nativeAd.callToAction, for: .normal)
        adMobView?.callToActionBtn.isHidden = nativeAd.callToAction == nil
        if let adMobView = adMobView {
        view.addSubview(adMobView)
        adMobViewConstraints()
    }
        
        
        print("Received unified native ad: \(type(of: nativeAd.mediaContent))")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
    
    var adLoader: GADAdLoader!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 1

        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/2521693316", rootViewController: self,
            adTypes: [GADAdLoaderAdType.unifiedNative],
            options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
        
    }
    
    func adMobViewConstraints() {
        adMobView?.translatesAutoresizingMaskIntoConstraints = false
//        adMobView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        adMobView?.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        adMobView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        adMobView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        adMobView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        adMobView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}
