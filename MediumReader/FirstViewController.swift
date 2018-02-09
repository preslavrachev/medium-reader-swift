//
//  FirstViewController.swift
//  MediumReader
//
//  Created by Preslav Rachev on 07/07/17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import UIKit
import ReadabilityKit

protocol PlayableDelegate {
    func articlePlayRequested(id: String, from requestor: Playable) -> Void
    func articlePauseRequested(id: String, from requestor: Playable) -> Void
}

extension UIViewController: ContextProvider {
    var contextProvider: ContextProvider {
        return UIApplication.shared.delegate as! ContextProvider
    }
    
    var context: Context {
        return contextProvider.context
    }
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlayableDelegate {
    
    private var currentPlayableRequestor: Playable?

    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var postCollectionView: UITableView!
    
    let cellId = "postCollectionCellId"
    
    var apiManager: MediumApiManager {
        return context.mediumApiManager
    }
    
    lazy var contentProcessor = ContentExtractorAndPostProcessor()
    
    var postCollection: PostCollection? = nil
    
    override func viewDidLoad() {
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
        
        if let posts = postCollection?.posts {
            let post: Post = posts[indexPath.row]
            cell.delegate = self
            cell.id = post.id
            cell.titleLabel?.text = post.title
            
            if let imageId = post.imageId {
                apiManager.fetchImage(with: imageId) {
                    imageData in cell.coverImage?.image = UIImage(data: imageData)
                }
            }
        }

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
    
    func articlePlayRequested(id: String, from requestor: Playable) -> Void {
        print("Article requested for playing: " + id)
        currentPlayableRequestor?.updatePlayingStatus(isPlaying: false)
        contentProcessor.fetchFullText(for: "https://medium.com/p/" + id) {
            fullText in print(fullText)
            DispatchQueue.main.async {
                print("Article will start playing: " + id)
                requestor.updatePlayingStatus(isPlaying: true)
                self.currentPlayableRequestor = requestor
            }
        }
    }
    
    func articlePauseRequested(id: String, from requestor: Playable) -> Void {
        print("Article requested for pausing: " + id)
        // TODO: request the main queue within the playable itself
        DispatchQueue.main.async {
            requestor.updatePlayingStatus(isPlaying: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
