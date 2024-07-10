//
//  PlayerManager.swift
//  Autocue
//
//  Created by 老沙 on 2023/8/2.
//

import AVKit
import AVFoundation

enum PlayDirection {
    case horizontal, vertical, center
}

enum PlayState {
    case play, stop, pause
}

protocol PlayManagerOutputProtocol: NSObjectProtocol {
    
    /// 获取自定义视图
    func getCustomView() -> UIView
    
    /// 更新播放状态
    func updateState(_ state: PlayState)
}

class PlayManager: NSObject, AVPictureInPictureControllerDelegate {
    
    static let share: PlayManager = PlayManager()
    
    var delegate:PlayManagerOutputProtocol?
    
    var isPictureInPictureSupported = false
    
    /// 播放器
    private var playerLayer = {
        let _mp4Video = Bundle.main.url(forResource: "竖向视频", withExtension: "mp4")
        let _asset = AVAsset.init(url: _mp4Video!)
        let _playerItem = AVPlayerItem.init(asset: _asset)
        
        let _player = AVPlayer.init(playerItem: _playerItem)
        _player.isMuted = true
        _player.allowsExternalPlayback = true
        let layer = AVPlayerLayer(player: _player)
        return layer
    }()
    
    /// 画中画
    private var pipController: AVPictureInPictureController?
    
    override init() {
        super.init()
        self.initUI()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== Init ====
    private func initUI() {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            isPictureInPictureSupported = true
            self.pipController = AVPictureInPictureController.init(playerLayer: playerLayer)
            // 隐藏播放按钮、快进快退按钮
            self.pipController?.setValue(1, forKey: "requiresLinearPlayback")
            // 进入后台自动开启画中画（必须处于播放状态）
            if #available(iOS 14.2, *) {
                self.pipController?.canStartPictureInPictureAutomaticallyFromInline = true
            } else {
                // Fallback on earlier versions
            }
        } else {
            isPictureInPictureSupported = false
            print("不支持画中画")
        }
    }
    
    private func bindProperty() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        } catch {
            print(error)
        }
        self.pipController?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier.invalid)
        }
    }
    
    // MARK: ==== Event ====
    
    func stop() {
        self.pipController?.stopPictureInPicture()
    }
    
    func changeDirection(_ type: PlayDirection) {
        // 窗口形状由视频形状决定
        var videoName = ""
        switch type {
        case .horizontal:
            videoName = "横向视频"
        case .vertical:
            videoName = "竖向视频"
        case .center:
            videoName = "方形视频"
        }
        guard let mp4Video = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            return
        }
        let asset = AVAsset.init(url: mp4Video)
        let playerItem = AVPlayerItem.init(asset: asset)
        
        self.playerLayer.player?.replaceCurrentItem(with: playerItem)
    }
    
    // MARK: - 旋转
    private var angle: Double = 0
    @objc private func rotate() {
        angle = angle + 0.5
        let window = UIApplication.shared.windows.first
        window?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * angle))
        
        let currentItem = playerLayer.player?.currentItem
        
        let mp4Video = Bundle.main.url(forResource: "方形视频", withExtension: "mp4")
        let asset = AVAsset.init(url: mp4Video!)
        let playerItem = AVPlayerItem.init(asset: asset)
        
        playerLayer.player?.replaceCurrentItem(with: playerItem)
        playerLayer.player?.replaceCurrentItem(with: currentItem)
    }
    
    // MARK: ==== Notification ====
    
    @objc private func handleEnterForeground() {
        print("进入前台");
    }
    
    @objc private func handleEnterBackground() {
        print("进入后台");
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        // 重新开始播放
        playerLayer.player?.seek(to: CMTime.zero)
        playerLayer.player?.play()
    }
    
    
    // MARK: ==== AVPictureInPictureControllerDelegate ====
    
    // 画中画将要弹出
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // 打印所有window
        print("画中画初始化后：\(UIApplication.shared.windows)")
        guard let _customView = self.delegate?.getCustomView() else {
            return
        }
        if let window = UIApplication.shared.windows.first {
            window.addSubview(_customView)
            // 使用自动布局
            _customView.snp.remakeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // 打印所有window
        print("画中画弹出后：\(UIApplication.shared.windows)")
        self.delegate?.updateState(.play)
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        self.delegate?.updateState(.pause)
    }
    
    // MARK: ==== PlayManagerInputProtocol ====
    //    func getPlayView() -> UIView {
    //        return playerView
    //    }
    
    func play() {
        self.playerLayer.player?.play()
        if self.pipController?.isPictureInPictureActive ?? false {
            self.pipController?.stopPictureInPicture()
        }
        self.pipController?.startPictureInPicture()
        
        self.playerLayer.frame = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIViewController.currentViewController?.view.layer.addSublayer(playerLayer)
    }
}
