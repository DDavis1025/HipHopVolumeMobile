//
//  PostRequests.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/1/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

enum APIError:Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct FollowerPostRequest {
    let resourceURL:URL
    
    init(endpoint:String) {
        let resourceString = "http://localhost:8000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save(_ followerToSave:Follower, completion: @escaping(Result<Follower, APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(followerToSave)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                do {
                    let followerData = try JSONDecoder().decode(Follower.self, from: jsonData)
                    completion(.success(followerData))
                } catch {
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
}
