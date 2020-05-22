//
//  DLTRequests.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/2/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

class DLTFollowingRequest {
    
    var id:String?
    init(id:String) {
      self.id = id
    }
    
    func delete(completion: @escaping(Error?) -> ()) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8000
        components.path = "/following/\(id!)"
        
        guard let url = URL(string: components.url!.absoluteString) else {
            fatalError("URL is not correct!")
            
        }

        print("URL \(url)")
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                
                if let err = err {
                    completion(err)
                    return
                }
        
                completion(nil)
           
            }
            dataTask.resume()
    }
}
