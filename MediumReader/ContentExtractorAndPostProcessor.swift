//
//  ContentExtractorAndPostProcessor.swift
//  MediumReader
//
//  Created by Preslav Rachev on 05.02.18.
//  Copyright © 2018 Preslav Rachev. All rights reserved.
//

import Foundation
import ReadabilityKit

class ContentExtractorAndPostProcessor {
    
    static let articlesKey = "articles"
    
    init() {
        if UserDefaults.standard.dictionary(forKey: ContentExtractorAndPostProcessor.articlesKey) == nil {
            let articles = [String: String]()
            UserDefaults.standard.set(articles, forKey: ContentExtractorAndPostProcessor.articlesKey)
        }
    }
    
    func fetchFullText(for urlString: String, completion: @escaping (_ fullText: String) -> Void) -> Void {
        let base64EncodedUrlString = Data(urlString.lowercased().utf8).base64EncodedString()
        var cachedArticles = UserDefaults.standard.dictionary(forKey: ContentExtractorAndPostProcessor.articlesKey)!
        
        if let fullText = cachedArticles[base64EncodedUrlString] as! String? {
            completion(fullText)
        } else {
            let articleUrl = URL(string: urlString)!
            
            Readability.parse(url: articleUrl, completion: { data in
                if let fullText = data?.text {
                    cachedArticles[base64EncodedUrlString] = fullText
                    UserDefaults.standard.setValue(cachedArticles, forKeyPath: ContentExtractorAndPostProcessor.articlesKey)
                    completion(fullText)
                }
            })
        }
    }
    
}
