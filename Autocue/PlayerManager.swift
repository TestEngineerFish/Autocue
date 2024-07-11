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

class PlayManager: NSObject, AVPictureInPictureControllerDelegate {
    
    static let share: PlayManager = PlayManager()
    
    
    var customView: CustomPipViewProtocol?
    
    /// 播放器
    private var playerLayer: AVPlayerLayer? = {
        guard let _mp4Video = ConfigModel.share.viewDirection.videoPath else {
            print("视频资源不存在")
            return nil
        }
        let _asset = AVAsset.init(url: _mp4Video)
        let _playerItem = AVPlayerItem.init(asset: _asset)
        
        let _player = AVPlayer(playerItem: _playerItem)
        _player.isMuted = true
        _player.allowsExternalPlayback = true
        let layer = AVPlayerLayer(player: _player)
        layer.frame = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
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
    
    deinit {
        // 移除 KVO 观察者
        self.playerLayer?.player?.removeObserver(self, forKeyPath: "timeControlStatus")
    }
    
    // MARK: ==== Init ====
    private func initUI() {
        if AVPictureInPictureController.isPictureInPictureSupported(), let layer = self.playerLayer {
            self.pipController = AVPictureInPictureController.init(playerLayer: layer)
            // 隐藏播放按钮、快进快退按钮
            self.pipController?.setValue(1, forKey: "requiresLinearPlayback")
            // 进入后台自动开启画中画（必须处于播放状态）
            if #available(iOS 14.2, *) {
                self.pipController?.canStartPictureInPictureAutomaticallyFromInline = true
            } else {
                // Fallback on earlier versions
            }
        } else {
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
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: AVPlayerItem.didPlayToEndTimeNotification, object: nil)
        UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier.invalid)
        }
        self.playerLayer?.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.new, .old], context: nil)
    }
    
    // MARK: ==== Event ====
    
    func play(_ view: CustomPipViewProtocol?) {
        guard let _playerLayer = self.playerLayer else {
            return
        }
        if _playerLayer.superlayer != nil {
            _playerLayer.removeFromSuperlayer()
        }
        self.customView = view
        
        _playerLayer.player?.play()
        
        if self.pipController?.isPictureInPictureActive ?? false {
            self.pipController?.stopPictureInPicture()
        }
        UIViewController.currentViewController?.view.layer.addSublayer(_playerLayer)
        self.pipController?.startPictureInPicture()
                if _playerLayer.player?.rate != 0 {
                    guard let _mp4Video = ConfigModel.share.viewDirection.videoPath else {
                        print("视频资源不存在")
                        return
                    }
                    let _asset = AVAsset.init(url: _mp4Video)
                    let _avPlayerItem = AVPlayerItem(asset: _asset)
                    _playerLayer.player?.replaceCurrentItem(with: _avPlayerItem)
                }
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
        self.playerLayer?.player?.seek(to: CMTime.zero)
        self.playerLayer?.player?.play()
    }
    
    // MARK: ==== KVO ====
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "timeControlStatus" {
                if self.playerLayer?.player?.timeControlStatus == .paused {
                    self.customView?.pause()
                } else if self.playerLayer?.player?.timeControlStatus == .playing {
                    self.customView?.start()
                }
            }
        }
    
    // MARK: ==== AVPictureInPictureControllerDelegate ====
    
    // 画中画将要弹出
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        guard let _customView = self.customView as? UIView else {
            return
        }
        _customView.tag = -1
        if let window = UIApplication.shared.windows.first {
            window.subviews.first(where: { $0.tag == -1 })?.removeFromSuperview()
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
        self.customView?.start()
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("画中画播放失败")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画 将要停止")
        self.customView?.pause()
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画 已停止")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print("画中画 关闭")
    }
}
