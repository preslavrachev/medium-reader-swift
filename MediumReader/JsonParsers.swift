//
//  JsonParsers.swift
//  MediumReader
//
//  Created by Preslav Rachev on 15.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import Foundation

extension Post {
    init?(json: [String: Any]) {
        self.id = json["id"] as! String
        self.title = json["title"] as! String
        if let virtuals = json["virtuals"] as? [String:Any] {
            if let previewImage = virtuals["previewImage"] as? [String:Any] {
                self.imageId = (previewImage["imageId"] as! String)
            }
        }
    }
}

extension PostCollection {
    init?(top_posts_json: [String: Any]) {
        self.success = top_posts_json["success"] as! Bool
        
        if (self.success == true) {
            if let payload = top_posts_json["payload"] as? [String:Any] {
                if let value = payload["value"] as? [String:Any] {
                    if let posts = value["posts"] as? [[String:Any]] {
                        self.posts = posts.map({ p in return Post(json: p)! })
                    }
                }
            }
        }
    }
    
    init?(tag_posts_json: [String: Any]) {
        self.success = tag_posts_json["success"] as! Bool
        
        if (self.success == true) {
            if let payload = tag_posts_json["payload"] as? [String:Any] {
                if let value = payload["references"] as? [String:Any] {
                    if let posts = value["Post"] as? [String:Any] {
                        self.posts = posts.map({ p in return Post(json: p.value as! [String:Any])! })
                    }
                }
            }
        }
    }
}
