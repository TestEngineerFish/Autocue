//
//  PlayerManager.swift
//  Autocue
//
//  Created by 老沙 on 2023/8/2.
//

import AVKit
import AVFoundation

class PlayManager {
    static let share = PlayManager()
    
    func play(model: BPCueModel) {
        composeVideoWithText(text: model.content, duration: 10.0) { videoURL in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.playerViewController = AVPlayerViewController()
                let player = AVPlayer(url: videoURL)
                self.playerViewController?.player = player
                
                UIViewController.currentViewController?.present(self.playerViewController!, animated: true) {
                    player.play()
                }
            }
        }
    }
    
    private var playerViewController: AVPlayerViewController?
    
    private func composeVideoWithText(text: String, duration: TimeInterval, playBlock: @escaping (URL)->Void) {
        let videoURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("textVideo.mp4")
        
        // 创建视频合成器
        let composition = AVMutableComposition()
        
        // 创建视频轨道
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        // 设置视频轨道的属性
        videoTrack?.preferredTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 2) // 旋转视频轨道以适应竖屏方向
        
        // 创建文本图层
        let textLayer = CATextLayer()
        textLayer.string = text
        // 设置文本图层的属性
        // ...
        
        // 创建视频轨道的时间范围
        let videoTimeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: duration, preferredTimescale: 1))
        
        
        // 创建一个合成器指令
        let compositionInstruction = AVMutableVideoCompositionInstruction()
        compositionInstruction.timeRange = videoTimeRange
        
        // 创建一个合成器层指令
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
        
        // 添加文本图层到合成器层指令
        layerInstruction.setTransform(videoTrack!.preferredTransform, at: .zero)
        layerInstruction.setOpacity(0.0, at: videoTimeRange.duration) // 在视频结束时隐藏文本图层
        
        // 添加合成器层指令到合成器指令
        compositionInstruction.layerInstructions = [layerInstruction]
        
        // 添加合成器指令到视频合成器
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = [compositionInstruction]
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30) // 设置帧率为30帧/秒
        videoComposition.renderSize = CGSize(width: 720, height: 1280) // 设置渲染尺寸，根据需要进行调整
        
        // 创建视频输出
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            print("无法创建AVAssetExportSession")
            return
        }
        exportSession.outputURL = videoURL
        exportSession.outputFileType = .mp4
        exportSession.videoComposition = videoComposition
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { [weak self] in
            guard let self = self else { return }
            // 导出完成后的处理
            if exportSession.status == .completed {
                // 视频合成成功，播放视频
                playBlock(videoURL)
            } else {
                // 视频合成失败，处理错误
                if let error = exportSession.error {
                    print("视频合成失败：\(error.localizedDescription)")
                }
            }
        }
    }
}
