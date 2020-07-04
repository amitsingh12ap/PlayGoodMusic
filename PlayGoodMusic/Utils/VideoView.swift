//
//  VideoView.swift
//  PlayerDemo
//
//  Created by 13216146 on 05/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
import AVFoundation
protocol VideoViewDelegate: class {
    func updatePlayerStatus(status: AVPlayerItem.Status)
    func updateCurrentTime(_ time: CMTime)
    
}
class VideoView: UIView {
    weak var delegate: VideoViewDelegate?
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    private var playerItemContext = 0
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    private func supportedStreamingQuality() {
        
    }
    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                completion?(asset)
            case .failed:
                print(".failed")
            case .cancelled:
                print(".cancelled")
            default:
                print("default")
            }
        }
    }
    
    private func setUpPlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)

        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
        }
    }
    private func addPeriodicTimeObserver() {
        // Notify every half second
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            
            if self.player!.currentItem?.status == .readyToPlay {
                self.delegate?.updateCurrentTime(self.player!.currentTime())
            }
        }

    }
    
    func getBitRate()-> Double?{
        
        let accessLog = self.playerItem?.accessLog()
        if let event = accessLog?.events.last {
            let utils = Utils(bytes: Int64(event.indicatedBitrate))
            print(utils.getReadableUnit())
        }
        return 0
    }
    
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            self.player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            self.delegate?.updatePlayerStatus(status: status)
            // Switch over status value
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                DispatchQueue.main.async {
                    self.addPeriodicTimeObserver()
                }
                player?.play()
            case .failed:
                print(".failed")
            case .unknown:
                print(".unknown")
            @unknown default:
                print("@unknown default")
            }
        }
    }
    
    var duration: CMTime? {
        return self.playerItem?.duration
    }
    func play(with url: URL) {
        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.setUpPlayerItem(with: asset)
        }
    }
    func play() {
        self.delegate?.updatePlayerStatus(status: .readyToPlay)
        self.player?.play()
    }
    
    func pause() {
        self.delegate?.updatePlayerStatus(status: .failed)
        self.player?.pause()
    }
    
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        print("deinit of PlayerView")
    }
}
