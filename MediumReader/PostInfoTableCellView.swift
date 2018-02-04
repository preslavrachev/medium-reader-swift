//
//  PostInfoTableCellView.swift
//  MediumReader
//
//  Created by Preslav Rachev on 21.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import UIKit

class PostInfoTableCellView: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var excerptLabel: UILabel?
    @IBOutlet weak var coverImage: UIImageView?
    
    var id: String?
    private var isPlaying: Bool = false
    
    
    @IBAction func handlePlayPause() {
        if let id = self.id {
            let notificationName = isPlaying ? InterAppNotification.requestArticlePause : InterAppNotification.requestArticlePlay
            NotificationCenter.default.post(name: notificationName.getNotificationName(),
                                            object: nil,
                                            userInfo: ["id": id])
        }
    }
    
    func updatePlyingStatus(isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
}
