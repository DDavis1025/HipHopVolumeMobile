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
    var userName:String?
    
    mutating func addUser(user: String) {
        userName = user
    }
}


struct PostById: Codable, Hashable, Identifiable {
    
    
    let id:String?
    let title:String?
    let album_id:String?
    let name: String?
    let path: String?
    let author:String?
    
}

struct UsersModel: Codable {
    var name:String?
    var username:String?
    var picture:String?
    var user_id:String?
    var email:String?
}

final class Follower: Codable {
    var user_id:String?
    var follower_id:String?
    
    init(user_id:String, follower_id:String) {
        self.user_id = user_id
        self.follower_id = follower_id
    }
}

struct Following: Codable, Hashable {
    var user_id:String?
    
}

struct Follows: Codable, Hashable {
    var follower_id:String?
    
}


struct ImageModel: Codable {
    var data:Data?
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
    static var theViewLoaded:Bool? = false
    static var justClicked:Bool? = false
    static var clickedFromAT:Bool? = false
    static var viewAppeared:Bool? = false
    
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
    
    func updateViewAppeared(newBool: Bool) {
        ModelClass.self.viewAppeared = newBool
    }
}
 

struct ArtistModel: Codable {
    var title:String?
    var id:String?
    var path:String?
}

struct UserPhoto: Codable {
    var path:String?
}


struct Email:Codable {
    var email:String?
}

struct Username:Codable {
    var username:String?
}

struct MediaPath:Codable {
    var path:String?
}

struct Author {
    static var author_id:String?
    
    func updateAuthorID(newString: String) {
        Author.self.author_id = newString
    }
}


final class Comment: Codable {
    var id:String?
    var post_id:String?
    var username:String?
    var user_picture:String?
    var user_id:String?
    var text:String?
    var parent_id:String?
    var comment_userID:String?
    var tableView_index:String?
    
    init(post_id:String, username:String, user_picture:String, user_id:String, text:String, parent_id: String?, comment_userID:String?, tableView_index:String?) {
        self.post_id = post_id
        self.username = username
        self.user_picture = user_picture
        self.user_id = user_id
        self.text = text
        self.parent_id = parent_id
        self.comment_userID = comment_userID
        self.tableView_index = tableView_index
    }
}

struct Comments: Codable {
    var id:String?
    var post_id:String?
    var text:String?
    var username:String?
    var user_picture:String?
    var user_id:String?
    var parent_id:String?
    var isliked:Bool?
    var numberOfLikes:Int?
}

final class CommentLike: Codable {
    var user_id:String?
    var comment_id:String?
    var post_id:String?
    var comment_userID:String?
    var tableView_index:String?
    
    init(user_id:String, comment_id:String, post_id:String, comment_userID:String, tableView_index:String) {
        self.user_id = user_id
        self.comment_id = comment_id
        self.post_id = post_id
        self.comment_userID = comment_userID
        self.tableView_index = tableView_index
    }
}

struct UserAndComment: Codable {
    var user_id:String?
    var comment_id:String?
}

struct CommentLikes: Codable {
    var user_id:String?
}

final class SubCommentLike: Codable {
    var isLiked:Bool?
    
    init(isLiked:Bool) {
        self.isLiked = isLiked
    }
}


struct Notifications: Codable {
    var user_id:String?
    var supporter_id:String?
    var message:String?
    var post_id:String?
    var parent_commentid:String?
    var comment_id:String?
}

struct PostPhoto: Codable {
    var path:String?
}



