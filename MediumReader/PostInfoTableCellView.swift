//
//  PostInfoTableCellView.swift
//  MediumReader
//
//  Created by Preslav Rachev on 21.07.17.
//  Copyright © 2017 Preslav Rachev. All rights reserved.
//

import UIKit

protocol Playable {
    func updatePlayingStatus(isPlaying: Bool) -> Void
}

class PostInfoTableCellView: UITableViewCell, Playable{
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var excerptLabel: UILabel?
    @IBOutlet weak var coverImage: UIImageView?
    @IBOutlet weak var playPauseButton: UIButton?
    
    var delegate: PlayableDelegate!
    
    var id: String?
    private var isPlaying: Bool = false
    
    
    @IBAction func handlePlayPause() {
        if let id = self.id {
            isPlaying ? delegate.articlePauseRequested(id: id, from: self) :
                delegate.articlePlayRequested(id: id, from: self)
            playPauseButton?.setTitle("Loading", for: .disabled)
            playPauseButton?.isEnabled = false
        }
    }
    
    func updatePlayingStatus(isPlaying: Bool) {
        self.isPlaying = isPlaying
        
        playPauseButton?.isEnabled = true
        playPauseButton?.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
    }
}
