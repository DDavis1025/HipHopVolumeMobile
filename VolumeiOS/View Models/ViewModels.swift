//
//  ViewModels.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/23/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

class GetUserByIDVM {
    
   
    var id:String?
    var usersDidChange: (([UsersModel]) -> ())?
    
 
    init(id: String) {
     self.id = id
     fetchUser()
    }
   
    var users = [UsersModel]() {
         didSet {
              usersDidChange?(users)
          }
    }
   
    func fetchUser() {
        GetUsersById(id: id!).getAllPosts {
        self.users = $0
            print("got users \(self.users)")
    }
    }
 
}



class GetUserByIDVM2 {
    
    var id:String?
    var usersDidChange: (([UsersModel]) -> ())?
   
    var users = [UsersModel]() {
         didSet {
              usersDidChange?(users)
          }
    }
   
    func getUser(id: String) {
        GetUsersById(id: id).getAllPosts {
        self.users = $0
        print("got users \(self.users)")
    }
  }
 
}

