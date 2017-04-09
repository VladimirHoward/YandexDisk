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
    
    var playerOn = false
    
    var currentIndex = 0
        
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var progressBarSlider: UISlider!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var timePast: UILabel!
    @IBOutlet weak var timeToGo: UILabel!
    @IBOutlet weak var miniPlayPause: UIButton!
    
    func setupNowPlayingInfoCenter()
    {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        MPRemoteCommandCenter.shared().playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.handleNext()
            return .success
        }
        
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.handleBack()
            return .success
        }
    }
    
    func updateNowPlayingCenter(title: String, currentTime: Double, songLength: Double){
        let songInfo: Dictionary <String, Any> = [
            MPMediaItemPropertyTitle: title,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: songLength,
            ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo as [String : Any]
    }
    
    func resetAudioPlayer()
    {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        audioPlayer = STKAudioPlayer(options: options)
        
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 0.5
        audioPlayer.delegate = self as STKAudioPlayerDelegate
        
        progressBarSlider.isContinuous = true
        progressBarSlider.addTarget(self, action: #selector (progressChanged), for: UIControlEvents.valueChanged)
        
        //синхронизация с аппаратным звуком?
        volumeSlider.value = audioPlayer.volume
        volumeSlider.addTarget(self, action: #selector(volumeChanged), for: UIControlEvents.valueChanged)
        
        playPauseButton.addTarget(self, action: #selector (handlePlayPause), for: .touchUpInside)
        miniPlayPause.addTarget(self, action: #selector (handlePlayPause), for: .touchUpInside)
        
        forwardButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        backwardButton.addTarget(self, action: #selector (handleBack), for: .touchUpInside)
        
        setupTimer()
    }
    
    func formatTimeFromSeconds (withTotalSeconds totalSeconds: Int) -> String
    {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        let returnString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        return returnString
    }
    
    func handleNext ()
    {
        YADMusicViewController.needToSwitchSong = true
        YADMusicViewController.next = true
    }
    
    func handleBack ()
    {
        YADMusicViewController.needToSwitchSong = true
        YADMusicViewController.prev = true
    }

    func handlePlayPause ()
    {
        if audioPlayer == nil
        {
            return
        }
        
        if audioPlayer.state == STKAudioPlayerState.paused
        {
            audioPlayer.resume()
            miniPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        else
        {
            audioPlayer.pause()
            miniPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    func progressChanged ()
    {
        if audioPlayer != nil
        {
            audioPlayer.seek(toTime: Double(progressBarSlider.value))
        }
        else
        {
            return
        }
    }
    
    func volumeChanged ()
    {
        if audioPlayer != nil
        {
            audioPlayer.volume = volumeSlider.value
        }
    }
    
    func tick()
    {
        if audioPlayer == nil
        {
            progressBarSlider.value = 0
        }
        
        if audioPlayer.duration != nil
        {
            progressBarSlider.minimumValue = 0
            progressBarSlider.maximumValue = Float(audioPlayer.duration)
            progressBarSlider.value = Float(audioPlayer.progress)
            
            timePast.text = formatTimeFromSeconds(withTotalSeconds: Int(audioPlayer.progress))
            timeToGo.text = formatTimeFromSeconds(withTotalSeconds: Int(audioPlayer.duration - audioPlayer.progress))
        }
        else
        {
            progressBarSlider.maximumValue = 0
            progressBarSlider.maximumValue = 0
            progressBarSlider.value = 0
        }
    }
    
    func updateControls()
    {
        tick()
    }
    
    func setupTimer()
    {
        let timer = Timer(timeInterval: 0.001, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    func playWithQueue(withQueue queue: [YADMusicModel], index: Int)
    {
        self.queue = queue
        
        if playerOn == false
        {
            resetAudioPlayer()
            
            audioPlayer.clearQueue()
            
            if queue[0].audioURL != ""
            {
                audioPlayer.play(queue[0].audioURL)
                songNameLabel.text = queue[0].name
                testLabel.text = queue[0].name
                YADMusicPlayerView.sharedInstance.isHidden = false
                currentIndex = index
                miniPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                playerOn = true
                
                updateNowPlayingCenter(title: queue[0].name, currentTime: audioPlayer.progress, songLength: audioPlayer.duration)
            }
        }
        else
        {
            if queue[0].audioURL != ""
            {
                audioPlayer.pause()
                audioPlayer.play(queue[0].audioURL)
                songNameLabel.text = queue[0].name
                testLabel.text = queue[0].name
                YADMusicPlayerView.sharedInstance.isHidden = false
                miniPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                currentIndex = index
                updateNowPlayingCenter(title: queue[0].name, currentTime: audioPlayer.progress, songLength: audioPlayer.duration)
            }
        }
        
        
    }
    
    //STKAudioPlayerDelegate methods
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject)
    {
        print("start playing music")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject)
    {

        updateNowPlayingCenter(title: queue[0].name, currentTime: audioPlayer.progress, songLength: audioPlayer.duration)
        
        print("update dataCenter")
        updateControls()

    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState)
    {
        updateNowPlayingCenter(title: queue[0].name, currentTime: audioPlayer.progress, songLength: audioPlayer.duration)
        print("state chanaged")
        updateControls()
    }

    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double)
    {
        print("playing finished")
        
       print("STOP REASON - \(stopReason.rawValue)")
        if stopReason == .eof
        {
            YADMusicViewController.needToSwitchSong = true
            YADMusicViewController.next = true
        }
        updateControls()

    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode)
    {
        print("error was occured")
        updateControls()
    }

    
//    internal func next()
//    {
//        guard queue.count > 0 else {
//            return
//        }
//        
//        currentIndex = (currentIndex + 1) % queue.count
//        playWithQueue(withQueue: queue, index: currentIndex)
//    }
    
//    internal func prev()
//    {
//        currentIndex = max(0, currentIndex - 1)
//        
//        playWithQueue(withQueue: queue, index: currentIndex)
//    }
    
//    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject)
//    {
//        if let index = (queue.index { $0.audioURL == queueItemId as! String})
//        {
//            currentIndex = index
//        }
//    }
    
   
    
//    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState)
//    {
//        audioPlayer.state = state
//        if state != .stopped && state != .error && state != .disposed
//        {
//            //handleUpdateDataCenter
//        }
//    }
//    
//    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double)
//    {
//        if let index = ( queue.index { $0.audioURL == audioPlayer.currentlyPlayingQueueItemId() as! String })
//        {
////            currentIndex = index
//        }
//        
//        if stopReason == .eof
//        {
////            next()
//        }
//        else if stopReason == .error
//        {
//            stop()
//            resetAudioPlayer()
//        }
//    }
//    
//    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode)
//    {
//        print("Error when playing music \(errorCode)")
//        resetAudioPlayer()
//        playWithQueue(withQueue: queue)
//    }
}

