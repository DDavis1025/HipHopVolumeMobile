//
//  Post.swift
//  Test
//
//  Created by Dillon Davis on 2/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import SwiftUI

struct Post: Codable, Hashable, Identifiable {
    
    let id: String?
    let title: String?
    let path: String
    let description: String?
    let author: String?
}


struct PostById: Codable, Hashable, Identifiable {
    
    
    let id:String
    let title:String?
    let album_id:String
    let name: String?
    let path: String
    let author:String?
   
    
}

struct UsersModel: Codable {
    var name:String?
    var picture:String?
    var user_id:String?
    var email:String?
}


class ModelClass : NSObject
{
    static var trackNameLabel:String?
    static var track:String? 
    static var listArray:[PostById]? = []
    static var index:Int?
    static var imgPath:String?
    static var post:Post?
    static var playing:Bool? = false
    static var theViewLoaded:Bool?
    static var justClicked:Bool?
    static var clickedFromAT:Bool? = false
    
    func updatePlaying(newBool: Bool) {
           ModelClass.self.playing = newBool
       }
    
    func updateTrackNameLabel(newText: String) {
        ModelClass.self.trackNameLabel = newText
    }
    
    func updateTrackPath(newText: String) {
        ModelClass.self.track = newText
    }
    
    func updateListArray(newList: [PostById]?) {
        ModelClass.self.listArray = newList
    }
    
    func updateIndex(newInt: Int) {
        ModelClass.self.index = newInt
    }
    
    func updateImgPath(newText: String) {
        ModelClass.self.imgPath = newText
    }
    
    func updatePost(newPost: Post) {
        ModelClass.self.post = newPost
    }
    
    func updateTheViewLoaded(newBool: Bool) {
        ModelClass.self.theViewLoaded = newBool
    }
    
    func updateJustClicked(newBool: Bool) {
        ModelClass.self.justClicked = newBool
    }
    
    func updateClickedFromAT(newBool: Bool) {
        ModelClass.self.clickedFromAT = newBool
    }
}
 

struct ArtistModel: Codable {
    var title:String?
    var id:String?
    var path:String?
}

