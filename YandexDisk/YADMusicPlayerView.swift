//
//  YADMusicPlayerView.swift
//  YandexDisk
//
//  Created by Gregory House on 23.03.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import StreamingKit
import MediaPlayer

class YADMusicPlayerView: UIView, STKAudioPlayerDelegate
{
    static let sharedInstance: YADMusicPlayerView = Bundle.main.loadNibNamed("YADPlayerViewController", owner: nil, options: nil)![0] as! YADMusicPlayerView
    
    var audioPlayer: STKAudioPlayer!
    
    var queue = [YADMusicModel]()
    
    var currentIndex = 0
    
    var loop = false
    
    var playerOn = false
    
    var play = false
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var progressBarSlider: UISlider!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var testLabel: UILabel!
    
    func resetAudioPlayer()
    {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        audioPlayer = STKAudioPlayer(options: options)
        
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 0.5
        audioPlayer.delegate = self as STKAudioPlayerDelegate
        
    }
    
    func playWithQueue(withQueue queue: [YADMusicModel], index: Int)
    {
        guard index >= 0 && index < queue.count else {
            return
        }
        
        if playerOn == false
        {
            resetAudioPlayer()
            
            self.queue = queue
            audioPlayer.clearQueue()
            
            if queue[index].audioURL != ""
            {
                audioPlayer.play(queue[index].audioURL)
                YADMusicPlayerView.sharedInstance.isHidden = false
            }
            
            testLabel.text = queue[index].name
            
            currentIndex = index
            
            loop = false
            
            playerOn = true
        }
        else
        {
            if queue[index].audioURL != ""
            {
                audioPlayer.pause()
                audioPlayer.play(queue[index].audioURL)
                YADMusicPlayerView.sharedInstance.isHidden = false
            }
        }
        
//        for i in 1 ..< queue.count
//        {
//            let url = queue[Int((index + i) % queue.count)].audioURL
//            audioPlayer.queue(URL(string: url)!)
//        }
        
    }
    
    internal func stop()
    {
        audioPlayer.stop()
        queue = []
        currentIndex = -1
    }
    
    internal func play(file: YADMusicModel)
    {
        audioPlayer.play(file.audioURL)
        play = true
    }
    
    internal func next()
    {
        guard queue.count > 0 else {
            return
        }
        
        currentIndex = (currentIndex + 1) % queue.count
        playWithQueue(withQueue: queue, index: currentIndex)
    }
    
    internal func prev()
    {
        currentIndex = max(0, currentIndex - 1)
        
        playWithQueue(withQueue: queue, index: currentIndex)
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject)
    {
        if let index = (queue.index { $0.audioURL == queueItemId as! String})
        {
            currentIndex = index
        }
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject)
    {
        //handleUpdateDataCenter
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState)
    {
        audioPlayer.state = state
        if state != .stopped && state != .error && state != .disposed
        {
            //handleUpdateDataCenter
        }
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double)
    {
        if let index = ( queue.index { $0.audioURL == audioPlayer.currentlyPlayingQueueItemId() as! String })
        {
            currentIndex = index
        }
        
        if stopReason == .eof
        {
            next()
        }
        else if stopReason == .error
        {
            stop()
            resetAudioPlayer()
        }
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode)
    {
        print("Error when playing music \(errorCode)")
        resetAudioPlayer()
        playWithQueue(withQueue: queue, index: currentIndex)
    }
}

