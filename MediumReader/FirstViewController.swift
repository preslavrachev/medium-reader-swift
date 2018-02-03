//
//  FirstViewController.swift
//  MediumReader
//
//  Created by Preslav Rachev on 07/07/17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import UIKit
import ReadabilityKit

extension UIViewController: ContextProvider {
    var contextProvider: ContextProvider {
        return UIApplication.shared.delegate as! ContextProvider
    }
    
    var context: Context {
        return contextProvider.context
    }
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var postCollectionView: UITableView!
    
    let cellId = "postCollectionCellId"
    
    var apiManager: MediumApiManager {
        return context.mediumApiManager
    }
    
    var postCollection: PostCollection? = nil
    
    override func viewDidLoad() {
        print("VIEW DID LOAD")
        super.viewDidLoad()
        tagCollectionView.dataSource = context.appState.tagViewDataSource
        tagCollectionView.delegate = AppState.TagViewDelegate()
        
        postCollectionView.register(UINib(nibName: "PostCollectionTableCell", bundle: nil), forCellReuseIdentifier: cellId)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let posts = postCollection?.posts.count else { return 0 }
        return posts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)! as! PostInfoTableCellView
        if let title = postCollection?.posts[indexPath.row].title {
            cell.titleLabel?.text = title
        }
        
        if let imageId = postCollection?.posts[indexPath.row].imageId {
            apiManager.fetchImage(with: imageId) {
                imageData in cell.coverImage?.image = UIImage(data: imageData)
            }
        }
        
        cell.excerptLabel?.text = postCollection?.posts[indexPath.row].excerpt
//        cell.articles = self.articles?[indexPath.row]
//        println("cellForRowAtIndexPath")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PostInfoTableCellView
        let post = (postCollection?.posts[indexPath.row])!
        
        let articleUrl = URL(string: "https://medium.com/p/" + post.id)!
        Readability.parse(url: articleUrl, completion: { data in
            let description = data?.description
            self.postCollection?.posts[indexPath.row].excerpt = description
            tableView.beginUpdates()
            cell.excerptLabel?.text = description
            tableView.endUpdates()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch context.appState.postListViewSelectedState {
        case .top:
            apiManager.fetchTopPosts {
                postCollection in
                self.postCollection = postCollection
                self.postCollectionView.reloadData()
            }
        case .tag(let selectedTag):
            apiManager.fetchTagPosts(tag: selectedTag) {
                postCollection in
                self.postCollection = postCollection
                self.postCollectionView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
