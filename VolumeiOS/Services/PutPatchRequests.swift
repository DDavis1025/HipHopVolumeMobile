//
//  PutPatchRequests.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/15/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

class UpdateUserInfo {
    
    func updateUserInfo(parameters:[String:String], user_id: String) {
        
        let headers = [
            "authorization": "Bearer \(accessToken)",
            "content-type": "application/json"
        ]
        print("parameters \(parameters)")
//        let parameters = ["user_metadata": ["addresses": ["home": "123 Main Street, Anytown, ST 12345"]]] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dev-owihjaep.auth0.com"
        components.path = "/api/v2/users/\(user_id)"
        
        print("components user patch \(components.url)")
        
        let request = NSMutableURLRequest(url: NSURL(string: components.url!.absoluteString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })
        
        dataTask.resume()
    }
}
