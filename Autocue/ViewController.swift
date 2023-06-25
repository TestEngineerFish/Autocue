//
//  ViewController.swift
//  Autocue
//
//  Created by 老沙 on 2023/6/25.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVPictureInPictureControllerDelegate {
    
    private var player = AVPlayer()
    private var playerViewController = AVPlayerViewController()
    
    private var playerLayer: AVPlayerLayer?
    private var pictureInViewController: AVPictureInPictureController?
    
    private let playButton = {
        let button = UIButton()
        button.setTitle("播放", for: .normal)
        button.backgroundColor = .orange
        button.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 50))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initUI()
    }
    
    // MARK: ==== UI ====
    private func initUI() {
        self.view.addSubview(playButton)
        playButton.center = self.view.center
        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
    }
    
    
    // MARK: ==== Event ====
    @objc
    private func playAction() {
        guard let url = Bundle.main.url(forResource: "HappyCow", withExtension: ".mp4") else {
            return
        }
        let item = AVPlayerItem(url: url)
        if AVPictureInPictureController.isPictureInPictureSupported() {
            print("支持")
            self.playAutocue(item: item)
        } else {
            print("不支持")
            self.playNormal(item: item)
        }
    }
    
    /// 开启画中画
    private func playAutocue(item: AVPlayerItem) {
        self.player.replaceCurrentItem(with: item)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = self.view.frame
        self.playerLayer?.videoGravity = .resizeAspect
        self.pictureInViewController = AVPictureInPictureController(playerLayer: self.playerLayer!)
        self.pictureInViewController?.delegate = self
        self.view.layer.addSublayer(self.playerLayer!)
        self.play()
    }
    
    /// 普通播放
    private func playNormal(item: AVPlayerItem) {
        self.player.replaceCurrentItem(with: item)
        self.playerViewController.player = self.player
        self.present(self.playerViewController, animated: true){
            self.play()
        }
    }
    
    private func play() {
        self.player.play()
    }
    
    private func pause() {
        self.player.pause()
    }
    
    // TODO: ==== AVPictureInPictureControllerDelegate ====
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController) async -> Bool {
        return true
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        
    }
    
    // TODO: ==== Tools ====
    private func transformVideo(cotent: String) {
        // 设置输出路径
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let outputPath = documentsPath.appendingPathComponent("output.mp4")
        let outputURL = URL(fileURLWithPath: outputPath)
        
        // 创建AVMutableComposition对象
        let composition = AVMutableComposition()
        
        // 创建AVMutableCompositionTrack对象，并将其添加到composition中
        guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            print("Failed to create video track")
            return
        }
        
        // 创建AVMutableCompositionTrack对象，并将其添加到composition中
        guard let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            print("Failed to create audio track")
            return
        }
        
        // 创建视频大小
        let videoSize = CGSize(width: 640, height: 480)
        
        // 创建视频转换图层
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        // 创建文本图层
        let textLayer = CATextLayer()
        textLayer.string = "Hello, World!"
        textLayer.font = UIFont.systemFont(ofSize: 30)
        textLayer.fontSize = 30
        textLayer.alignmentMode = .center
        textLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        
        // 创建视频合成指令
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: .zero, duration: composition.duration)
        
        // 创建视频合成图层指令
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        layerInstruction.setTransform(videoTrack.preferredTransform, at: .zero)
        
        // 添加文本图层到视频合成图层
        let animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: instruction)
        animationTool?.animationLayer = textLayer
        
        // 创建视频合成
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = [instruction]
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.renderSize = videoSize
        videoComposition.animationTool = animationTool
        
        // 创建AVAssetExportSession对象
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            print("Failed to create export session")
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.videoComposition = videoComposition
        
        // 导出视频
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("Video export completed: \(outputURL)")
            case .failed:
                print("Video export failed: \(exportSession.error?.localizedDescription ?? "")")
            case .cancelled:
                print("Video export cancelled")
            default:
                break
            }
        }
    }
    
}

