//
//  MediumApiManager.swift
//  MediumReader
//
//  Created by Preslav Rachev on 19.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import Foundation

protocol MediumApiManager {
    func fetchTopPosts(cb: @escaping (PostCollection) -> Void)
}

class DefaultMediumApiManager: MediumApiManager {
    func fetchTopPosts(cb: @escaping (PostCollection) -> Void) {
        let url = URL(string: "https://medium.com/top-stories?format=json")
        let task = URLSession.shared.dataTask(with: url!) {(data,b,c) in
            print("data loaded")
            var prunedData = data
            prunedData?.removeFirst(16)
            var dataAsString = NSString(data: prunedData!, encoding: String.Encoding.utf8.rawValue)
            //dataAsString = dataAsString?.replacingOccurrences(of: "])}while(1);</x>", with: "") as! NSString
            
            let json = try? JSONSerialization.jsonObject(with: prunedData!, options: []) as! [String: Any]
            let postCollection = PostCollection(json: json!)
            print("data: \(postCollection)")
            
            cb(postCollection!)
        }
        
        task.resume()
    }
}
