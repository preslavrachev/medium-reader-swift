//
//  AppState.swift
//  MediumReader
//
//  Created by Preslav Rachev on 28.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import Foundation
import UIKit

class AppState {
    class TagViewDataSource: NSObject, UICollectionViewDataSource {
        
        var dataProvider: () -> Array<String> = { return [""] }
        
        override init() {
        }
        
        public func registerDataProvider(dataProvider: @escaping () -> Array<String>) {
            self.dataProvider = dataProvider
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dataProvider().count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let tagViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagViewCell.reusableId, for: indexPath) as! TagViewCell
            tagViewCell.label.text = dataProvider()[indexPath.row]
            return tagViewCell
        }
    }
    
    var postListViewSelectedState = PageType.top
    let tags: Array<String> = ["Swift", "Kotlin", "Bitcoin", "Ethereum"]
    
    public let tagViewDataSource: TagViewDataSource = TagViewDataSource();
    
    
    init() {
        tagViewDataSource.registerDataProvider {
            return self.tags
        }
    }
}
