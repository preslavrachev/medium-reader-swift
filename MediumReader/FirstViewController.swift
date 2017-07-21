//
//  FirstViewController.swift
//  MediumReader
//
//  Created by Preslav Rachev on 07/07/17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import UIKit

extension UIViewController: ContextProvider {
    var contextProvider: ContextProvider {
        return UIApplication.shared.delegate as! ContextProvider
    }
    
    var context: Context { return contextProvider.context }
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postCollectionView: UITableView!
    
    var apiManager: MediumApiManager {
        return context.mediumApiManager
    }
    
    var postCollection: PostCollection? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        
        apiManager.fetchTopPosts {
            postCollection in
            self.postCollection = postCollection
            self.postCollectionView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let posts = postCollection?.posts.count else { return 0 }
        return posts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell")!
        if let postId = postCollection?.posts[indexPath.row].id {
            cell.textLabel?.text = postId
        }
//        cell.articles = self.articles?[indexPath.row]
//        println("cellForRowAtIndexPath")
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

