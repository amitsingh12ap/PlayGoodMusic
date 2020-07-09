//
//  PlayerViewController.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 27/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleCast

//let streamURL = "http://lmil.live-s.cdn.bitgravity.com/cdn-live/_definst_/lmil/live/aajtak_app.smil/playlist.m3u8"

class PlayerViewController: BaseViewController, UIGestureRecognizerDelegate, GCKSessionManagerListener {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var videoView: VideoView!
    
    public var urlString: String?
    public var selectedIndex: Int?
    public var videoList: [Live]?
    
    private var isAllButtonsHide: Bool = false
    private var isLive:Bool = false
    private var curPlayerStatus: AVPlayerItem.Status?
    private var playerInLandscape: Bool = false
    private var playerVM = PlayerVM()
    private var sessionManager: GCKSessionManager!
    
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var liveContainerStckView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var ContainerHeight: NSLayoutConstraint!
    
    var mediaView: UIView!
    
    
    var timer: Timer?
    var isAllwedToPlay: Bool = false
    var count = 60.0
    var isSubscribedUser: Bool = false
    private var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController!
    var subscriptionModel: SubscriptionModel?
    override func viewDidLoad() {
        sessionManager = GCKCastContext.sharedInstance().sessionManager
        seekBar.setThumbImage(#imageLiteral(resourceName: "seekThumb"), for: .normal)
        super.viewDidLoad()
        self.videoView.delegate = self
        playVideo()
        self.addTapGesture()
        if isLive {
//            self.seekBar.isHidden = true
        }
        
        self.view.bringSubviewToFront(self.backButton)
        
        self.getUserActivePacks()
    }
    private func createChromeCastMediaContainer() {
        mediaView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 70 - (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!, width: self.view.frame.width, height: 70))
        
        self.view.addSubview(mediaView!)
        
        let castContext = GCKCastContext.sharedInstance()
        sessionManager.add(self)
        miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        miniMediaControlsViewController.delegate = self
        updateControlBarsVisibility(shouldAppear: true)
        installViewController(miniMediaControlsViewController, inContainerView: mediaView!)
    }
    func installViewController(_ viewController: UIViewController?, inContainerView containerView: UIView) {
        if let viewController = viewController {
            addChild(viewController)
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
    func updateControlBarsVisibility(shouldAppear: Bool = false) {
        if shouldAppear {
            mediaView!.isHidden = false
        } else {
            //            mediaView!.isHidden = true
        }
        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        view.setNeedsLayout()
    }
    func getUserActivePacks() {
        LoadingView.showLoader(withTitle: "Please wait...", toView: self.view)
        self.playerVM.getUserSubscription {[weak self] (model, error) in
            LoadingView.hideLoader()
            if let apiError = error {
                self?.showAlert("Error", apiError.localizedDescription)
                return
            }
//            let liveData = self?.videoList?[self?.selectedIndex ?? 0]
//            let subscribedChannels = packages as? [String]
            
            if let subscriptionModel = model {
                self?.subscriptionModel = subscriptionModel
                
            }
            if !(self?.validateChannel() ?? false) {
                self?.scheduleTimer()
                self?.isSubscribedUser = false
            }
            
            
        }
    }
    
    private func validateChannel()->Bool {
        if let subscriptionModel = self.subscriptionModel {
            if subscriptionModel.result.packagesList.count > 0 {
                if let channelId = self.videoList?[self.selectedIndex ?? 0].channelid {
                    if subscriptionModel.result.packagesList.contains(channelId) {
                        self.isSubscribedUser = true
                        return true
                    }
                }
            } else if subscriptionModel.result.subsLiveItem.count > 0 {
                if let channelId = self.videoList?[self.selectedIndex ?? 0].channelid {
                    if subscriptionModel.result.subsLiveItem.contains(channelId) {
                        self.isSubscribedUser = true
                        return true
                    }
                }
            } else if subscriptionModel.result.subsVODItem.count > 0 {
                if let channelId = self.videoList?[self.selectedIndex ?? 0].channelid {
                    if subscriptionModel.result.subsVODItem.contains(channelId) {
                        self.isSubscribedUser = true
                        return true
                    }
                }
            }
        }
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        if !isSubscribedUser && Utils.isUserLoggedIn() && count >= 120{
            let channelData:[String: String] = ["channelName": self.videoList?[self.selectedIndex ?? 0].title ?? ""]
            NotificationCenter.default.post(name: Notification.Name(kForceSubscription), object: channelData)
        }
    }
    
    private func scheduleTimer() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: self.count, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc private func fireTimer() {
        if count < 120 {
            self.showAlert("Message", "you currently using 2 minutes free content access. Your access will remove after \(120 - count) second.")
            count += 30
            timer?.invalidate()
            self.scheduleTimer()
        } else {
            self.timer?.invalidate()
            if Utils.isUserLoggedIn() {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.videoView.pause()
                self.navigateToLogin()
            }
        }
        
    }
    
    func addTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(gestureRecognizer:)))
        self.videoView.addGestureRecognizer(tapRecognizer)
               tapRecognizer.delegate = self
    }
    
     func playVideo() {
        guard let _ = self.urlString, let url = URL(string: urlString ?? "")  else { return }
         videoView.play(with: url)

    }
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        self.hideAllPlayerButtons(!isAllButtonsHide)
    }
    @IBAction func playAction(_ sender: Any) {
        self.playBtn.isSelected = !self.playBtn.isSelected
        if let status = self.curPlayerStatus {
            if status == .readyToPlay {
                self.videoView.pause()
            } else {
                self.videoView.play()
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.hideUnhideNextButton()
        guard var index = self.selectedIndex else {
            return
        }
        index += 1
        self.selectedIndex = index
        DispatchQueue.main.async {
            self.validateAndPlay()
        }
        
    }
    @IBAction func backwardAction(_ sender: Any) {
        self.seekTo(-10)
    }
    deinit {
        self.timer?.invalidate()
        self.videoView.pause()
        self.videoView.removePeriodicTimeObserver()
    }
    @IBAction func rotateAction(_ sender: Any) {
        if !playerInLandscape {
            playerInLandscape = true
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            self.tableView.isHidden = true
            
        } else {
            playerInLandscape = false
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            self.tableView.isHidden = false
        }
    }
    
    override func updatePlayerView(_ isLandscape: Bool) {
        if isLandscape {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
    }
    
    @IBAction func popAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func hideUnhideNextButton() {
        guard let index = self.selectedIndex, index + 1 < self.videoList?.count ?? 0  else {
            self.nextBtn.isUserInteractionEnabled = false
            self.nextBtn.tintColor = UIColor.gray
            return
        }
        self.nextBtn.isUserInteractionEnabled = true
        self.nextBtn.tintColor = UIColor.white
    }
    private func validateAndPlay() {
        self.hideUnhideNextButton()
        self.urlString = self.videoList?[self.selectedIndex ?? 0].url
        self.playVideo()
        self.tableView.reloadData()
        
    }
    
    @IBAction func cast(_ sender: Any) {
        self.configureMetaData()
    }
}
extension PlayerViewController : VideoViewDelegate {
    
    
    func updatePlayerStatus(status: AVPlayerItem.Status) {
        self.curPlayerStatus = status
        self.playBtn.isSelected = status == .readyToPlay
        if status == .readyToPlay {
//            print(self.videoView.getBitRate())
            self.hideAllPlayerButtons(true)
            if let seconds = videoView.duration?.seconds, !seconds.isNaN , !isLive {
                self.seekBar.maximumValue = Float(seconds)
            }
        }
    }
    func hideAllPlayerButtons(_ shouldHide: Bool) {
        isAllButtonsHide = shouldHide
        self.backwardBtn.isHidden = shouldHide
        self.nextBtn.isHidden = shouldHide
        self.playBtn.isHidden = shouldHide
        if !isLive {
//            self.seekBar.isHidden = shouldHide
        }
        
    }
    
    func updateCurrentTime(_ time: CMTime) {
        DispatchQueue.main.async {
            self.seekBar.value = Float(time.seconds)
        }
        
    }
    func seekTo(_ seekDuration: Float64) {
        guard let player = videoView.player else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = playerCurrentTime + seekDuration

        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
}
extension PlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if videoList?.count ?? 0 > 0 {
            return 80
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width - 20, height: 15))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text  = self.videoList?[self.selectedIndex ?? 0].title
        titleLabel.textColor = .white
        headerView.addSubview(titleLabel)
        let descrptionLabel = UILabel(frame: CGRect(x: 10, y: (titleLabel.frame.origin.y + titleLabel.frame.size.height) , width: tableView.frame.size.width - 20, height: 15))
        descrptionLabel.font = UIFont.boldSystemFont(ofSize: 10)
        descrptionLabel.text =  self.videoList?[self.selectedIndex ?? 0].des
        descrptionLabel.textColor = .lightGray
        headerView.addSubview(descrptionLabel)
        let moreLiveLabel = UILabel(frame: CGRect(x: 10, y: descrptionLabel.frame.origin.y + descrptionLabel.frame.size.height, width: tableView.frame.size.width - 20, height: 40))
        moreLiveLabel.font = UIFont.boldSystemFont(ofSize: 20)
        moreLiveLabel.text = "More Live Videos"
        moreLiveLabel.textColor = .white
        headerView.addSubview(moreLiveLabel)
        headerView.backgroundColor = .black
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveCell") as! LiveEventCell
        let eventInfo = self.videoList?[indexPath.row]
        let imageLoader = ImageCacheLoader()
        if let urlString = eventInfo?.thumbnail.small {
            imageLoader.fetchImage(imagePath: urlString) { (image) in
                cell.thumnail.image = image
                cell.thumnail.layer.cornerRadius = 10
            }
        }
        cell.headerLbl.text = eventInfo?.title
        if let eventDesc = eventInfo?.des {
            cell.subHeaderLbl.text = eventDesc
        } else {
            cell.subHeaderLbl.isHidden = true
        }
        if indexPath.row == selectedIndex {
            cell.nowPlayingLbl.isHidden = false
        } else {
            cell.nowPlayingLbl.isHidden = true
        }
        cell.eventDateLbl.text = Utils.getDate(dateString: eventInfo?.publishDate ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if self.selectedIndex != indexPath.row {
                self.timer?.invalidate()
                self.scheduleTimer()
                self.selectedIndex = indexPath.row
                self.validateAndPlay()
            }
            
        }
    }
}
extension PlayerViewController {
    func configureMetaData() {
        if GCKCastContext.sharedInstance().castState == .connected {
            print("connected")
            let url = URL.init(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_20MB.mp4")
            guard let mediaURL = url else {
                print("invalid mediaURL")
                return
            }
            
            let metadata = GCKMediaMetadata()
            metadata.setString("sddsfasfdas", forKey: kGCKMetadataKeyTitle)
            metadata.setString("sadfasfasfdasfd",
                               forKey: kGCKMetadataKeySubtitle)
            metadata.addImage(GCKImage(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg")!,
                                       width: 480,
                                       height: 360))
            
            let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: mediaURL)
            mediaInfoBuilder.streamType = GCKMediaStreamType.buffered;
            mediaInfoBuilder.contentType = "video/mp4"
            mediaInfoBuilder.metadata = metadata
            mediaInfoBuilder.startAbsoluteTime = .greatestFiniteMagnitude
            let mediaInformation = mediaInfoBuilder.build()
            
            if let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInformation) {
                request.delegate = self
            }
            GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
        }
        else {
           
        }
        
    }
}
extension PlayerViewController: GCKRequestDelegate,GCKUIMiniMediaControlsViewControllerDelegate {
    func requestDidComplete(_ request: GCKRequest) {
        print("request completed")
    }
    
    func request(_ request: GCKRequest, didAbortWith abortReason: GCKRequestAbortReason) {
        print("aborted")
    }
    
    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        print("failed")
    }
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
        updateControlBarsVisibility(shouldAppear: shouldAppear)
    }
}
