//
//  InterAppNotification.swift
//  MediumReader
//
//  Created by Preslav Rachev on 04.02.18.
//  Copyright © 2018 Preslav Rachev. All rights reserved.
//

import Foundation

enum InterAppNotification: String {
    case requestArticlePlay = "requestArticlePlay"
    case requestArticlePause = "requestArticlePause"
    case requestArticleStop = "requestArticleStop"
    
    func getNotificationName() -> Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
