//
//  Webservice.swift
//  Test
//
//  Created by Dillon Davis on 2/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

struct AccessToken {
 var accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik5FRTVPRGt4TWpaR05UQXhNRGN6UkRsQ09UaEVSa0UzTTBVeE16Z3hNa1JETmpZd016UXpNQSJ9.eyJpc3MiOiJodHRwczovL2Rldi1vd2loamFlcC5hdXRoMC5jb20vIiwic3ViIjoiTUdkbmIzOUZVYjY3WThMMVB2YmhUaGtLa3hTNWd2UmlAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vZGV2LW93aWhqYWVwLmF1dGgwLmNvbS9hcGkvdjIvIiwiaWF0IjoxNTk3MzM3MDgzLCJleHAiOjE1OTc0MjM0ODMsImF6cCI6Ik1HZG5iMzlGVWI2N1k4TDFQdmJoVGhrS2t4UzVndlJpIiwic2NvcGUiOiJyZWFkOmNsaWVudF9ncmFudHMgY3JlYXRlOmNsaWVudF9ncmFudHMgZGVsZXRlOmNsaWVudF9ncmFudHMgdXBkYXRlOmNsaWVudF9ncmFudHMgcmVhZDp1c2VycyB1cGRhdGU6dXNlcnMgZGVsZXRlOnVzZXJzIGNyZWF0ZTp1c2VycyByZWFkOnVzZXJzX2FwcF9tZXRhZGF0YSB1cGRhdGU6dXNlcnNfYXBwX21ldGFkYXRhIGRlbGV0ZTp1c2Vyc19hcHBfbWV0YWRhdGEgY3JlYXRlOnVzZXJzX2FwcF9tZXRhZGF0YSByZWFkOnVzZXJfY3VzdG9tX2Jsb2NrcyBjcmVhdGU6dXNlcl9jdXN0b21fYmxvY2tzIGRlbGV0ZTp1c2VyX2N1c3RvbV9ibG9ja3MgY3JlYXRlOnVzZXJfdGlja2V0cyByZWFkOmNsaWVudHMgdXBkYXRlOmNsaWVudHMgZGVsZXRlOmNsaWVudHMgY3JlYXRlOmNsaWVudHMgcmVhZDpjbGllbnRfa2V5cyB1cGRhdGU6Y2xpZW50X2tleXMgZGVsZXRlOmNsaWVudF9rZXlzIGNyZWF0ZTpjbGllbnRfa2V5cyByZWFkOmNvbm5lY3Rpb25zIHVwZGF0ZTpjb25uZWN0aW9ucyBkZWxldGU6Y29ubmVjdGlvbnMgY3JlYXRlOmNvbm5lY3Rpb25zIHJlYWQ6cmVzb3VyY2Vfc2VydmVycyB1cGRhdGU6cmVzb3VyY2Vfc2VydmVycyBkZWxldGU6cmVzb3VyY2Vfc2VydmVycyBjcmVhdGU6cmVzb3VyY2Vfc2VydmVycyByZWFkOmRldmljZV9jcmVkZW50aWFscyB1cGRhdGU6ZGV2aWNlX2NyZWRlbnRpYWxzIGRlbGV0ZTpkZXZpY2VfY3JlZGVudGlhbHMgY3JlYXRlOmRldmljZV9jcmVkZW50aWFscyByZWFkOnJ1bGVzIHVwZGF0ZTpydWxlcyBkZWxldGU6cnVsZXMgY3JlYXRlOnJ1bGVzIHJlYWQ6cnVsZXNfY29uZmlncyB1cGRhdGU6cnVsZXNfY29uZmlncyBkZWxldGU6cnVsZXNfY29uZmlncyByZWFkOmhvb2tzIHVwZGF0ZTpob29rcyBkZWxldGU6aG9va3MgY3JlYXRlOmhvb2tzIHJlYWQ6ZW1haWxfcHJvdmlkZXIgdXBkYXRlOmVtYWlsX3Byb3ZpZGVyIGRlbGV0ZTplbWFpbF9wcm92aWRlciBjcmVhdGU6ZW1haWxfcHJvdmlkZXIgYmxhY2tsaXN0OnRva2VucyByZWFkOnN0YXRzIHJlYWQ6dGVuYW50X3NldHRpbmdzIHVwZGF0ZTp0ZW5hbnRfc2V0dGluZ3MgcmVhZDpsb2dzIHJlYWQ6c2hpZWxkcyBjcmVhdGU6c2hpZWxkcyBkZWxldGU6c2hpZWxkcyByZWFkOmFub21hbHlfYmxvY2tzIGRlbGV0ZTphbm9tYWx5X2Jsb2NrcyB1cGRhdGU6dHJpZ2dlcnMgcmVhZDp0cmlnZ2VycyByZWFkOmdyYW50cyBkZWxldGU6Z3JhbnRzIHJlYWQ6Z3VhcmRpYW5fZmFjdG9ycyB1cGRhdGU6Z3VhcmRpYW5fZmFjdG9ycyByZWFkOmd1YXJkaWFuX2Vucm9sbG1lbnRzIGRlbGV0ZTpndWFyZGlhbl9lbnJvbGxtZW50cyBjcmVhdGU6Z3VhcmRpYW5fZW5yb2xsbWVudF90aWNrZXRzIHJlYWQ6dXNlcl9pZHBfdG9rZW5zIGNyZWF0ZTpwYXNzd29yZHNfY2hlY2tpbmdfam9iIGRlbGV0ZTpwYXNzd29yZHNfY2hlY2tpbmdfam9iIHJlYWQ6Y3VzdG9tX2RvbWFpbnMgZGVsZXRlOmN1c3RvbV9kb21haW5zIGNyZWF0ZTpjdXN0b21fZG9tYWlucyB1cGRhdGU6Y3VzdG9tX2RvbWFpbnMgcmVhZDplbWFpbF90ZW1wbGF0ZXMgY3JlYXRlOmVtYWlsX3RlbXBsYXRlcyB1cGRhdGU6ZW1haWxfdGVtcGxhdGVzIHJlYWQ6bWZhX3BvbGljaWVzIHVwZGF0ZTptZmFfcG9saWNpZXMgcmVhZDpyb2xlcyBjcmVhdGU6cm9sZXMgZGVsZXRlOnJvbGVzIHVwZGF0ZTpyb2xlcyByZWFkOnByb21wdHMgdXBkYXRlOnByb21wdHMgcmVhZDpicmFuZGluZyB1cGRhdGU6YnJhbmRpbmcgcmVhZDpsb2dfc3RyZWFtcyBjcmVhdGU6bG9nX3N0cmVhbXMgZGVsZXRlOmxvZ19zdHJlYW1zIHVwZGF0ZTpsb2dfc3RyZWFtcyBjcmVhdGU6c2lnbmluZ19rZXlzIHJlYWQ6c2lnbmluZ19rZXlzIHVwZGF0ZTpzaWduaW5nX2tleXMiLCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMifQ.d5rW6QWSBH8I9i_VBe9Ce2wWOisXQBtK-1HA7fXbEg256O6zNtwIo9EW5Vy3GXRL9cSBs3JMkHip1PIS8y9Ls6VjW0bic0-JUbslbXIEc666ShT7tWi7AiasYsjSedoBDOt-b5sYXCnd82O780N2kH4ivwt-0OH_4FXEcNe87PDi23V1EegK55-vsTE4z0x7K_r-H3E6_NOZFnpFEcYo5ooMlced_TxpHl-WgWxQPe7B1pIfsM7USFej-TvA1oyyki0lHmpFwN4A-jqKjfm3a7vbIaikAP4hWimv9SNYh8d9qnsOfjd4CudW6l-Y08NuF-_OZeKZ2D2TgRiykn8cnA"
}

class Webservice {
    func getAllPosts(completion: @escaping ([Post]) -> ()) {
        guard let url = URL(string: "http://localhost:8000/albums")
     else {
     fatalError("URL is not correct!")
    }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            let posts = try!
    
                JSONDecoder().decode([Post].self, from: data!); DispatchQueue.main.async {
                    completion(posts)
            }
        }.resume()
    }
}

class GetAllOfMediaType {
    var path:String?
    init(path:String) {
        self.path = path
    }
    func getAllPosts(completion: @escaping ([Post]) -> ()) {
        if let path = self.path {
        guard let url = URL(string: "http://localhost:8000/\(path)")
     else {
     fatalError("URL is not correct!")
    }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            let posts = try!
    
                JSONDecoder().decode([Post].self, from: data!); DispatchQueue.main.async {
                    completion(posts)
            }
        }.resume()
     }
   }
}
  
  
class GETAlbum: Identifiable {
    var id:String = ""
        
    init(id: String?) {
        self.id = id!
        }
        
    func getPostsById(completion: @escaping (Post) -> ()) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8000
        components.path = "/albums/\(id)"
        guard let url = URL(string: components.url!.absoluteString)
        else {
        fatalError("URL is not correct!")
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
        
            if let error = error {
                print("Error \(error)")
                return
            }
            
            guard let posts = try? JSONDecoder().decode([Post].self, from: data!) else {
                print("Unable to decode user posts")
                return
            }
            
            DispatchQueue.main.async {
                completion(posts.first!)
                print("the posts \(posts)")
            }
        }.resume()
    }
}

    
class SecondWebService: Identifiable {
    var id:String = ""
        
    init(id: String?) {
        self.id = id!
        }
    
        
    func getAllPostsById(completion: @escaping ([PostById]) -> ()) {
        var components = URLComponents()
           components.scheme = "http"
           components.host = "localhost"
           components.port = 8000
           components.path = "/albums/\(id)"
        guard let url = URL(string: components.url!.absoluteString)
        else {
         fatalError("URL is not correct!")
       }

        URLSession.shared.dataTask(with: url) { data, _, error in
    
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let posts = try? JSONDecoder().decode([PostById].self, from: data!) else {
                print("Unable to decode user posts")
                completion([])
                return
            }
            DispatchQueue.main.async {
                completion(posts)
            }
        }.resume()
    }
}



class GetUsersWebservice {
   
    func getAllPosts(completion: @escaping ([UsersModel]) -> ()) {
        
        
        var components = URLComponents()
           components.scheme = "https"
           components.host = "dev-owihjaep.auth0.com"
           components.path = "/api/v2/users"
           components.queryItems = [
             URLQueryItem(name: "", value: "email:\("")"),
            ]


           let url = components.url
        
        print("Components.url: \(components.url)")
        

         guard let requestUrl = url else { fatalError() }
         var request = URLRequest(url: requestUrl)
         request.httpMethod = "GET"
//         accessToken = ""
        let accessToken = AccessToken().accessToken
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        print("access 1 \(accessToken)")

        print("REquesturl \(requestUrl)")
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            let posts = try!
    
                JSONDecoder().decode([UsersModel].self, from: data!); DispatchQueue.main.async {
                    completion(posts)
                    print("posts \(posts)")
            }
        }.resume()
    }
}


class GetUsersById {

    var id:String
    var dataTask:URLSessionDataTask?
    
    init(id:String) {
        self.id = id
    }
    
    
    func getAllPosts(completion: @escaping ([UsersModel]) -> ()) {
        
        
        var components = URLComponents()
           components.scheme = "https"
           components.host = "dev-owihjaep.auth0.com"
           components.path = "/api/v2/users/\(id)"


        let url = components.url
        
        print("Components users by id url: \(components.url!)")
        

         guard let requestUrl = url else { fatalError() }
         var request = URLRequest(url: requestUrl)
         request.httpMethod = "GET"
//         accessToken = ""
        let accessToken = AccessToken().accessToken
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        print("access 2 \(accessToken)")

        print("REquesturl \(requestUrl)")
        dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print("Error Getusersbyid \(error)")
                return
            }
            
            let posts = try!
                
                JSONDecoder().decode(UsersModel.self, from: data!); DispatchQueue.main.async {
                    completion([posts])
                    print("posts this \([posts])")
                    print("request URL \(requestUrl)")
                    
            }
        }
        dataTask?.resume()
        
    }
}

//GET ARTIST ALBUMS
class GETArtistById: Identifiable {
    var id:String = ""
        
    init(id: String?) {
        self.id = id!
        print("Self id \(self.id)")
        }
    
        
    func getAllById(completion: @escaping ([ArtistModel]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/artist/\(id)"
                  
                 let url = components.url
        
                print("url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            let posts = try!
    
                JSONDecoder().decode([ArtistModel].self, from: data!); DispatchQueue.main.async {
                    completion(posts)
            }
        }.resume()
    }
}

//GET ARTIST TRACKS OR VIDEOS
class GETArtistById2: Identifiable {
    var id:String = ""
    var path:String = ""
        
    init(id: String?, path:String) {
        if let id = id {
        self.id = id
        }
        self.path = path
        print("Self id \(self.id)")
        }
    
        
    func getAllById(completion: @escaping ([ArtistModel]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/\(path)/\(id)"
                  
                 let url = components.url
        
                print("url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            let posts = try!
    
                JSONDecoder().decode([ArtistModel].self, from: data!); DispatchQueue.main.async {
                    completion(posts)
            }
        }.resume()
    }
}


class GETUsersByFollowerId: Identifiable {
    var id:String = ""
        
    init(id: String?) {
        if let id = id {
        self.id = id
        }
        }
    
        
    func getAllById(completion: @escaping ([Following]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/following/\(id)"
                  
                 let url = components.url
        
                print("url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            let following = try!
    
                JSONDecoder().decode([Following].self, from: data!); DispatchQueue.main.async {
                    completion(following)
            }
        }.resume()
    }
}


class GETFollowersByUserID: Identifiable {
    var id:String = ""
        
    init(id: String?) {
        self.id = id!
        print("Self id \(self.id)")
        }
    
        
    func getAllById(completion: @escaping ([Follows]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/follows/\(id)"
                  
                 let url = components.url
        
                print("url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            let following = try!
    
                JSONDecoder().decode([Follows].self, from: data!); DispatchQueue.main.async {
                    completion(following)
            }
        }.resume()
    }
}


class GETUserPhotoByID: Identifiable {
    var id:String = ""
        
    init(id: String?) {
        self.id = id!
        print("Self id \(self.id)")
        }
    
        
    func getPhotoById(completion: @escaping ([UserPhoto]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/user/\(id)"
                  
                 let url = components.url
        
                print("url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            let user = try!
    
                JSONDecoder().decode([UserPhoto].self, from: data!);
                DispatchQueue.main.async {
                    completion(user)
            }
        }.resume()
    }
}



class EmailValidation {

    var dataTask:URLSessionDataTask?
    
    func getEmail(email:String, completion: @escaping ([Email]) -> ()) {
        
        var components = URLComponents()
           components.scheme = "https"
           components.host = "dev-owihjaep.auth0.com"
           components.path = "/api/v2/users-by-email"
           components.queryItems = [
           URLQueryItem(name: "email", value: "\(email)"),
          ]


        let url = components.url
        
        print("Components url email: \(components.url!)")
        

         guard let requestUrl = url else { fatalError() }
         var request = URLRequest(url: requestUrl)
         request.httpMethod = "GET"
//         accessToken = ""
        let accessToken = AccessToken().accessToken
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print("Error \(error)")
                return
            }
            
            guard let email = try? JSONDecoder().decode([Email].self, from: data!) else {
                print("Unable to decode usernames")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(email)
                print("email \(email)")
            }
        }
                    
        dataTask?.resume()
        
    }
}



class UsernameValidation {

    var dataTask:URLSessionDataTask?
    
    func getUsername(username:String, completion: @escaping ([Username]) -> ()) {
        
        var components = URLComponents()
           components.scheme = "https"
           components.host = "dev-owihjaep.auth0.com"
           components.path = "/api/v2/users"
           components.queryItems = [
           URLQueryItem(name: "q", value: "username:\"\(username)\""),
          ]


        let url = components.url
        
        print("Components url username: \(components.url!)")
        

         guard let requestUrl = url else { fatalError() }
         var request = URLRequest(url: requestUrl)
         request.httpMethod = "GET"
//         accessToken = ""
        let accessToken = AccessToken().accessToken
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")


        dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print("Error \(error)")
                return
            }
            
           guard let username = try? JSONDecoder().decode([Username].self, from: data!) else {
              print("Unable to decode usernames")
              DispatchQueue.main.async {
                 completion([])
              }
              return
            }
                
                DispatchQueue.main.async {
                    completion(username)
                    print("username \(username)")
                }
                    
        }
        dataTask?.resume()
        
    }
}


class GetMedia{
    var id:String
    var path:String
    init(id:String, path:String) {
        self.id = id
        self.path = path
    }
    
    func getMedia(completion: @escaping ([MediaPath]) -> ()) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8000
        components.path = "/\(path)/\(id)"
        
        
        if let components_url = components.url?.absoluteString {
        print("get media url \(components_url)")
        guard let url = URL(string: components_url)
        else {
        fatalError("URL is not correct!")
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            

            guard let path = try? JSONDecoder().decode([MediaPath].self, from: data!) else {
             print("Unable to decode path")
             return
            }
            
            DispatchQueue.main.async {
                completion(path)
            }

        }.resume()
     }
  }
}

class GETComments: Identifiable {
    var id:String = ""
    var path:String = ""
        
    init(id: String?, path: String?) {
        if let id = id, let path = path {
         self.id = id
         self.path = path
        }
        
    }
    
    func getAllById(completion: @escaping ([Comments]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/\(path)/\(id)"
                  
                 let url = components.url
        
                print("url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
             guard let comments = try? JSONDecoder().decode([Comments].self, from: data!) else {
               print("Unable to decode comments")
               return
              }
                
                DispatchQueue.main.async {
                    completion(comments)
                    print("comments \(comments)")
                }
            
        }.resume()
    }
}

class GETSubComments: Identifiable {
    var id:String = ""
    var path:String = ""
    var offset:String = ""
    
    init(id: String?, path: String?, offset:String?) {
        if let id = id, let path = path, let offset = offset{
         self.id = id
         print("sub id \(id)")
         self.path = path
         print("sub path \(path)")
         self.offset = offset
         print("sub offset \(offset)")
        }
        
    }
    
        
    func getAllById(completion: @escaping ([Comments]) -> ()) {
        
//        let queryItems = [URLQueryItem(name: "offset", value: offset), URLQueryItem(name: "replyFrom", value: jumpedToReply[0]), URLQueryItem(name: "replyTo", value: jumpedToReply[1]) ]
         let queryItems = [URLQueryItem(name: "offset", value: offset)]
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/\(path)/\(id)"
                  components.queryItems = queryItems
                  
                 let url = components.url
        
                print("GETSubComments url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return
            }
             guard let comments = try? JSONDecoder().decode([Comments].self, from: data) else {
               print("Unable to decode sub comments")
               return
              }
                
                DispatchQueue.main.async {
                    completion(comments)
                    print("comments \(comments)")
                }
            
        }.resume()
    }
}


class GETCommentLikes: Identifiable {
    var id:String = ""
    
    init(id: String?) {
        if let id = id {
         self.id = id
        }
        
    }
    
        
    func getAllById(completion: @escaping ([CommentLikes]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/commentLikes/\(id)"
                  
                 let url = components.url
        
                print("sub comments url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
             guard let commentLikes = try? JSONDecoder().decode([CommentLikes].self, from: data!) else {
               print("Unable to decode comment likes")
               return
              }
                
                DispatchQueue.main.async {
                    completion(commentLikes)
                }
            
        }.resume()
    }
}


class GETCommentLikesByUserID: Identifiable {
    var comment_id:String?
    var user_id:String?
    
    init(comment_id: String?, user_id: String?) {
        if let comment_id = comment_id, let user_id = user_id {
         self.comment_id = comment_id
         self.user_id = user_id
        }
        
    }
    
        
    func getAllById(completion: @escaping ([CommentLikes]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
        if let comment_id = comment_id, let user_id = user_id {
                  components.path = "/commentLikesByUserID/\(comment_id)/\(user_id)"
        }
                  
                 let url = components.url
        
                print("user id exists url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
             guard let commentLikes = try? JSONDecoder().decode([CommentLikes].self, from: data!) else {
               print("Unable to decode comment likes")
               return
              }
                
                DispatchQueue.main.async {
                    completion(commentLikes)
                }
            
        }.resume()
    }
}


class GETSubCommentAfterReply: Identifiable {
    var id:String = ""
    var user_id:String = ""
    
    
    init(id: String?, user_id:String?) {
        if let id = id, let user_id = user_id {
         self.id = id
         self.user_id = user_id
        }
        
    }
    
        
    func getSubComment(completion: @escaping ([Comments]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/singleComment/\(id)/\(user_id)"
                  
                 let url = components.url
        
                print("single sub comment url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return
            }
             guard let comments = try? JSONDecoder().decode([Comments].self, from: data) else {
               print("Unable to decode sub comments after reply")
               return
              }
                
                DispatchQueue.main.async {
                    completion(comments)
                    print("comments \(comments)")
                }
            
        }.resume()
    }
}


class GETCommentByUser: Identifiable {
    var id:String = ""
    var user_id:String = ""
    
    
    init(id: String?, user_id:String?) {
        if let id = id, let user_id = user_id {
         self.id = id
         self.user_id = user_id
        }
        
    }
    
        
    func getComments(completion: @escaping ([UserAndComment]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/commentByUser/\(id)/\(user_id)"
                  
                 let url = components.url
        
                print("get comment by user \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
             guard let comments = try? JSONDecoder().decode([UserAndComment].self, from: data!) else {
               print("Unable to decode comment by user")
               return
              }
                
                DispatchQueue.main.async {
                    completion(comments)
                    print("comments \(comments)")
                }
            
        }.resume()
    }
}


class GETNotificationsByUserID: Identifiable {
    var user_id:String = ""
    
    
    init(user_id:String?) {
        if let user_id = user_id {
         self.user_id = user_id
        }
        
    }
    
        
    func getNotifications(completion: @escaping ([Notifications]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/getNotications/\(user_id)"
                  
                 let url = components.url
        
                print("notifications url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
             guard let notifications = try? JSONDecoder().decode([Notifications].self, from: data!) else {
               print("Unable to decode notifications")
               return
              }
                
                DispatchQueue.main.async {
                    completion(notifications)
                    print("notifications \(notifications)")
                }
            
        }.resume()
    }
}



class GETPostImageById: Identifiable {
    var id:String = ""
    
    
    init(id:String?) {
        if let id = id {
         self.id = id
        }
        
    }
    
        
    func getPost(completion: @escaping ([PostImage]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/getPostImage/\(id)"
                  
                 let url = components.url
        
                print("post photo by id url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else {
                return
            }
             guard let post = try? JSONDecoder().decode([PostImage].self, from: data) else {
               print("Unable to decode post photo comments")
                completion([])
               return
              }
                
                DispatchQueue.main.async {
                    completion(post)
                    print("post \(post)")
                }
            
        }.resume()
    }
}


class GETSongData: Identifiable {
    var id:String = ""
    
    
    init(id:String?) {
        if let id = id {
         self.id = id
        }
        
    }
    
        
    func getSong(completion: @escaping ([Song]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/getSongData/\(id)"
                  
                 let url = components.url
        
                print("post photo by id url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else {
                return
            }
             guard let song = try? JSONDecoder().decode([Song].self, from: data) else {
               print("Unable to decode post photo comments")
                completion([])
               return
              }
                
                DispatchQueue.main.async {
                    completion(song)
                }
            
        }.resume()
    }
}


class NotificationSubComment: Identifiable {
    var id:String = ""
    
    init(id:String?) {
        if let id = id {
         self.id = id
        }
        
    }
    
        
    func getComments(completion: @escaping ([Comments]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/getSubCommentsNoticationsById/\(id)"
                  
                 let url = components.url
        
                print("get sub comments notification url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else {
                return
            }
             guard let subComments = try? JSONDecoder().decode([Comments].self, from: data) else {
               print("Unable to decode sub comments notification")
                completion([])
               return
              }
                
                DispatchQueue.main.async {
                    completion(subComments)
                }
            
        }.resume()
    }
}


class ParentSubCommentAndReply: Identifiable {
    var parentsubcommentid:String = ""
    var reply_id:String = ""
    
    init(parentsubcommentid:String?, reply_id:String?) {
        if let parentsubcommentid = parentsubcommentid, let reply_id = reply_id {
         self.parentsubcommentid = parentsubcommentid
         self.reply_id = reply_id
        }
        
    }
    
        
    func getComments(completion: @escaping ([Comments]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/getParentSubCommentAndReply/\(reply_id)/\(parentsubcommentid)"
                  
                 let url = components.url
        
                print("get sub comments notification url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else {
                return
            }
             guard let subComments = try? JSONDecoder().decode([Comments].self, from: data) else {
               print("Unable to decode sub comments notification")
                completion([])
               return
              }
                
                DispatchQueue.main.async {
                    completion(subComments)
                }
            
        }.resume()
    }
}


class GETCommentById: Identifiable {
    var id:String = ""
    
    init(id:String?) {
        if let id = id {
         self.id = id
        }
        
    }
    
        
    func getComment(completion: @escaping ([Comments]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/getComment/\(id)"
                  
                 let url = components.url
        
                print("get comment by id \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else {
                return
            }
             guard let comments = try? JSONDecoder().decode([Comments].self, from: data) else {
               print("Unable to decode comment by id")
                completion([])
               return
              }
                
                DispatchQueue.main.async {
                    completion(comments)
                }
            
        }.resume()
    }
}


class GETMediaById: Identifiable {
    var id:String = ""
    var path:String = ""
    
    init(id:String?, path:String?) {
        if let id = id, let path = path {
         self.id = id
         self.path = path
        }
        
    }
    
        
    func getMedia(completion: @escaping ([PostById]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
                  components.path = "/\(path)/\(id)"
                  
                 let url = components.url
        
                print("get media by id \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else {
                return
            }
             guard let video = try? JSONDecoder().decode([PostById].self, from: data) else {
               print("Unable to decode media by id")
               completion([])
               return
              }
                
                DispatchQueue.main.async {
                    completion(video)
                }
            
        }.resume()
    }
}



class GETLikeRequest: Identifiable {
    var path:String?
    var post_id:String?
    var supporter_id:String?
    
    init(path: String?, post_id: String?, supporter_id: String?) {
        if let path = path, let post_id = post_id, let supporter_id = supporter_id {
            self.path = path
            self.post_id = post_id
            self.supporter_id = supporter_id
        } else if let path = path, let post_id = post_id {
            self.path = path
            self.post_id = post_id
        }
        
    }
    
        
    func getLike(completion: @escaping ([LikeModel]) -> ()) {
        
        var components = URLComponents()
                  components.scheme = "http"
                  components.host = "localhost"
                  components.port = 8000
              if let path = path, let post_id = post_id, let supporter_id = supporter_id {
                  components.path = "/\(path)/\(post_id)/\(supporter_id)"
              } else if let path = path, let post_id = post_id {
                  components.path = "/\(path)/\(post_id)/"
              }
                  
                 let url = components.url
        
                print("get like url \(url)")
                
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else {
                return
            }
             guard let likes = try? JSONDecoder().decode([LikeModel].self, from: data) else {
               print("Unable to decode likes")
               completion([])
               return
              }
                
                DispatchQueue.main.async {
                    completion(likes)
                }
            
        }.resume()
    }
}

class GETByID: Identifiable {
    var id:String = ""
    var path:String = ""
        
    init(id: String?, path:String?) {
        if let id = id, let path = path {
            self.id = id
            self.path = path
        }
    }
    
        
    func getById(completion: @escaping ([PostById]) -> ()) {
        var components = URLComponents()
           components.scheme = "http"
           components.host = "localhost"
           components.port = 8000
           components.path = "/\(path)/\(id)"
        
        print("get by id url \(components.url?.absoluteString)")
        
        guard let url = URL(string: components.url!.absoluteString)
          else {
          fatalError("URL is not correct!")
       }

        URLSession.shared.dataTask(with: url) { data, _, error in
    
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let data = data else {
                return
            }
            guard let responseData = try? JSONDecoder().decode([PostById].self, from: data) else {
                print("Unable to decode responseData")
                completion([])
                return
            }
            DispatchQueue.main.async {
                completion(responseData)
                print("responseData \(responseData)")
            }
        }.resume()
    }
}


class GetUsersById2: Identifiable {

    var id:String = ""
    
    init(id:String?) {
        if let id = id {
        self.id = id
        }
    }
    
    
    func getUser(completion: @escaping (User) -> ()) {
        
        
        var components = URLComponents()
           components.scheme = "https"
           components.host = "dev-owihjaep.auth0.com"
           components.path = "/api/v2/users/\(id)"


        let url = components.url
        
        print("Components users by id url 2: \(components.url!)")
        

         guard let requestUrl = url else { fatalError() }
         var request = URLRequest(url: requestUrl)
         request.httpMethod = "GET"
//         accessToken = ""
        let accessToken = AccessToken().accessToken
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        print("access 2 \(accessToken)")

        print("REquesturl \(requestUrl)")
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print("Error Getusersbyid \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                print("Unable to decode responseData")
                return
            }
            DispatchQueue.main.async {
                completion(user)
                print("GetUsersById2 user \(user)")
            }
            
        }.resume()
    }
}
