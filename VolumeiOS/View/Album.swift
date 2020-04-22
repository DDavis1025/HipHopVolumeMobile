//
//  Album.swift
//  Test
//
//  Created by Dillon Davis on 3/17/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import SwiftUI
import UIKit
struct Album: View {
    
    var post:Post?
//    var post2:[PostById]
    @ObservedObject var model = PostListViewModel()
    @ObservedObject var model2 = PostListViewByIdModel()
    var components = URLComponents()
    var viewController:UIViewController?
   
 init(post: Post) {
    self.post = post
    print("post Album \(post)")
    viewController = ViewController(post:post)

//    var components = URLComponents()
       components.scheme = "http"
       components.host = "localhost"
       components.port = 8000
       components.path = "/\(post.path)"

}



   
    
    var body: some View {
             VStack {
               Text("Title: ").bold()
                + Text("\(self.post!.title!)")
                ImageView(withURL: components.url!.absoluteString)
//                print("\(components.url!)")
                   Text("Description: ").bold()
                    + Text("\(self.post!.description!)")
                IntegratedController(post: self.post!)
                
        }
        
    
    }

}


    



                   

