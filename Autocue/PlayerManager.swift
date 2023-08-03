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

class PlayManager: UIView, AVPictureInPictureControllerDelegate {
    static let share = PlayManager(frame: .zero)
    
    // 播放器
    private var playerLayer: AVPlayerLayer?
    
    // 画中画
    private var pipController: AVPictureInPictureController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        if AVPictureInPictureController.isPictureInPictureSupported() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            } catch {
                print(error)
            }
            let _playerLayer = AVPlayerLayer()
            _playerLayer.frame = .init(x: 90, y: 90, width: 200, height: 150)
            
            let _mp4Video = Bundle.main.url(forResource: "竖向视频", withExtension: "mp4")
            let _asset = AVAsset.init(url: _mp4Video!)
            let _playerItem = AVPlayerItem.init(asset: _asset)
            
            let _player = AVPlayer.init(playerItem: _playerItem)
            _player.isMuted = true
            _player.allowsExternalPlayback = true
            _playerLayer.player = _player
            _player.play()
            self.playerLayer = _playerLayer
            let _pipController = AVPictureInPictureController.init(playerLayer: _playerLayer)!
            // 隐藏播放按钮、快进快退按钮
            _pipController.setValue(1, forKey: "requiresLinearPlayback")
            // 进入后台自动开启画中画（必须处于播放状态）
            if #available(iOS 14.2, *) {
                _pipController.canStartPictureInPictureAutomaticallyFromInline = true
            } else {
                // Fallback on earlier versions
            }
            _pipController.delegate = self
            self.pipController = _pipController
            setupCustomView()
            NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        } else {
            print("不支持画中画")
        }
        
        UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier.invalid)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play(model: BPCueModel) {
//        textView.text = model.content
//        playerLayer?.player?.play()
        if pipController?.isPictureInPictureActive ?? false {
            pipController?.stopPictureInPicture()
        } else {
            pipController?.startPictureInPicture()
        }
    }
    
    func stop() {
        if pipController?.isPictureInPictureActive ?? false {
            pipController?.stopPictureInPicture()
        }
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
        let mp4Video = Bundle.main.url(forResource: videoName, withExtension: "mp4")
        let asset = AVAsset.init(url: mp4Video!)
        let playerItem = AVPlayerItem.init(asset: asset)
        
        playerLayer?.player?.replaceCurrentItem(with: playerItem)
    }
    
    // MARK: - 旋转
    private var angle: Double = 0
    @objc private func rotate() {
        angle = angle + 0.5
        let window = UIApplication.shared.windows.first
        window?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * angle))
        
        let currentItem = playerLayer?.player?.currentItem
        
        let mp4Video = Bundle.main.url(forResource: "方形视频", withExtension: "mp4")
        let asset = AVAsset.init(url: mp4Video!)
        let playerItem = AVPlayerItem.init(asset: asset)
        
        playerLayer?.player?.replaceCurrentItem(with: playerItem)
        playerLayer?.player?.replaceCurrentItem(with: currentItem)
    }
    
    

    

    // 你的自定义view
    var customView: UIView!
    var textView: UITextView!
    // timer
    private var displayerLink: CADisplayLink!
    
    
    // 配置自定义view
    private func setupCustomView() {
        customView = UIView()
        customView.backgroundColor = .blue
        
        textView = UITextView()
        textView.text = "asfasfasdfsf"
        textView.backgroundColor = .clear
        textView.textColor = .red
        textView.isUserInteractionEnabled = false
        customView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    // 开始滚动
    private func startTimer() {
        if displayerLink != nil {
            displayerLink.invalidate()
            displayerLink = nil
        }
        displayerLink = CADisplayLink.init(target: self, selector: #selector(move))
        displayerLink.preferredFramesPerSecond = 30
        let currentRunloop = RunLoop.current
        // 常驻线程
        currentRunloop.add(Port(), forMode: .default)
        displayerLink.add(to: currentRunloop, forMode: .default)
    }
    
    // 停止滚动
    private func stopTimer() {
        if displayerLink != nil {
            displayerLink.invalidate()
            displayerLink = nil
        }
    }
    
    @objc private func move() {
        let offsetY = textView.contentOffset.y
        textView.contentOffset = .init(x: 0, y: offsetY + 1)
        if textView.contentOffset.y > textView.contentSize.height {
            textView.contentOffset = .zero
        }
    }
    
    
    // MARK: - 进入前后台
    
    @objc private func handleEnterForeground() {
        print("进入前台");
    }
    
    @objc private func handleEnterBackground() {
        print("进入后台");
    }
    
    
    // MARK: - AVPictureInPictureControllerDelegate
    
    // 画中画将要弹出
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // 打印所有window
        print("画中画初始化后：\(UIApplication.shared.windows)")
        // 注意是 first window
        if let window = UIApplication.shared.windows.first {
            // 把自定义view加到画中画上
            window.addSubview(customView)
            // 使用自动布局
            customView.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
            }
            window.backgroundColor = .clear
            var superView: UIView? = window.superview
            while superView != nil {
                superView?.backgroundColor = .clear
                superView = superView?.superview
            }
            UIApplication.shared.windows.forEach { w in
                w.backgroundColor = .clear
            }
        }
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        startTimer()
        // 打印所有window
        print("画中画弹出后：\(UIApplication.shared.windows)")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        stopTimer()
    }
    
}
