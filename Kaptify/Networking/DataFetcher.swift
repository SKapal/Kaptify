//
//  DataFetcher.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-18.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import Foundation

class DataFetcher {
    
    var albums = [Album]()
    
    func obtainData(jsonString: String, completion: @escaping ([Album]?, Error?)->Void) {
        //Networking (Remove later)
//        let jsonString = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json"
        guard let url = URL(string: jsonString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check error
            // check response (200)
            
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(object.self, from: data)
                guard let results = obj.feed?.results else {
                    completion(nil, error)
                    return
                }
                completion(results, nil)
                
            } catch let jsonError {
                print("Error with json", jsonError)
            }
            
            }.resume()
    }
    
}
