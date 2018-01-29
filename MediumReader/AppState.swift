//
//  AppState.swift
//  MediumReader
//
//  Created by Preslav Rachev on 28.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import Foundation
import UIKit

protocol AppStateChangeHandler {
    func onStateChange(newState: PageType) -> Void
}

class AppState {
    
    class TagViewDelegate: NSObject, UICollectionViewDelegate {
        var handler: (PageType) -> Void = { _ in /* does nothing */ }
            
        func registerStateSwitchHandler(handler: @escaping (PageType) -> Void) {
            self.handler = handler
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as! TagViewCell
            handler(PageType.tag(tag: (cell.label?.text)!))
        }
    }
    
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
    var stateChangeHandlers:Array<AppStateChangeHandler> = []
    
    public let tagViewDataSource: TagViewDataSource = TagViewDataSource();
    
    
    init() {
        tagViewDataSource.registerDataProvider {
            return self.tags
        }
    }
    
    func registerStateChangeHandler(stateChangeHandler: AppStateChangeHandler) -> Void {
        stateChangeHandlers.append(stateChangeHandler)
    }
}
