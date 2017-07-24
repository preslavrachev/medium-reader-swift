//
//  MediumApiManager.swift
//  MediumReader
//
//  Created by Preslav Rachev on 19.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import Foundation

protocol MediumApiManager {
    func fetchTopPosts(callback: @escaping (PostCollection) -> Void)
    func fetchImage(with imageId: String, callback: @escaping (Data) -> Void)
}

private class MediumURLSessionDelegate: NSObject, URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
        
        //NOTE: This method will be called only in case a task does not provide its own completion handler
        completionHandler(proposedResponse)
    }
}

class DefaultMediumApiManager: MediumApiManager {
    
    private let urlSession: URLSession = {
        let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
        // Always cache by default, let the separate requests decide whether to ignore caching or not
        urlSessionConfiguration.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        
        return URLSession(
            configuration: urlSessionConfiguration,
            delegate: MediumURLSessionDelegate(),
            delegateQueue: OperationQueue.main
        )
    }()
    
    init() {
        Swift.print(urlSession.delegate!)
    }
    
    func fetchTopPosts(callback: @escaping (PostCollection) -> Void) {
        let url = URL(string: "https://medium.com/top-stories?format=json")
        let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData)
        
        let task = urlSession.dataTask(with: request) {(data, response, error) in
            print("data loaded")
            var prunedData = data
            prunedData?.removeFirst(16)
            
            let json = try? JSONSerialization.jsonObject(with: prunedData!, options: []) as! [String: Any]
            let postCollection = PostCollection(json: json!)
            
            DispatchQueue.main.async {
                callback(postCollection!)
            }
        }
        
        task.resume()
    }
    
    func fetchImage(with imageId: String, callback: @escaping (Data) -> Void) {
        let url = URL(string: "https://cdn-images-1.medium.com/max/800/" + imageId)
        let task = urlSession.dataTask(with: url!)
        {(data, response, error) in
            // TODO: handle potential errors
            
            DispatchQueue.main.async {
                callback(data!)
            }
        }
        
        task.resume()
    }
}
