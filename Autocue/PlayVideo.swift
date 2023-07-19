//
//  PlayVideo.swift
//  Autocue
//
//  Created by 老沙 on 2023/7/3.
//

import AVFoundation
import Photos
import AVKit

class PlayVideo {
//    func composeVideoWithText(text: String, duration: TimeInterval, playbackRate: Float) {
//        let videoURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("textVideo.mp4")
//
//        // 创建视频合成器
//        let videoComposition = AVMutableComposition()
//
//        // 创建视频轨道
//        let videoTrack = videoComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
//        // 设置视频轨道的属性
//        videoTrack?.preferredTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 2) // 旋转视频轨道以适应竖屏方向
//
//        // 创建文本图层
//        let textLayer = CATextLayer()
//        textLayer.string = text
//        // 设置文本图层的属性
//        // ...
//
//        // 创建视频轨道的时间范围
//        let videoTimeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: duration, preferredTimescale: 1))
//
//        // 创建一个合成器指令
//        let compositionInstruction = AVMutableVideoCompositionInstruction()
//        compositionInstruction.timeRange = videoTimeRange
//
//        // 创建一个合成器层指令
//        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
//
//        // 添加文本图层到合成器层指令
//        layerInstruction.setTransform(videoTrack!.preferredTransform, at: .zero)
//        layerInstruction.setOpacity(0.0, at: videoTimeRange.duration) // 在视频结束时隐藏文本图层
//
//        // 添加合成器层指令到合成器指令
//        compositionInstruction.layerInstructions = [layerInstruction]
//
//        // 添加合成器指令到视频合成器
//        let mVideoComposition = AVMutableVideoComposition()
//        mVideoComposition.instructions = [compositionInstruction]
//        mVideoComposition.frameDuration = CMTime(value: 1, timescale: 30) // 设置帧率为30帧/秒
//        mVideoComposition.renderSize = CGSize(width: 720, height: 1280) // 设置渲染尺寸，根据需要进行调整
//
//        // 创建视频输出
//        let videoExport = AVAssetExportSession(asset: videoComposition, presetName: AVAssetExportPresetHighestQuality)
//        videoExport?.outputURL = videoURL
//        videoExport?.outputFileType = .mp4
//        videoExport?.videoComposition = mVideoComposition
//        videoExport?.shouldOptimizeForNetworkUse = true
//        videoExport?.exportAsynchronously { [weak self] in
//            guard let self = self else { return }
//            // 导出完成后的处理
//            if videoExport?.status == .completed {
//                // 视频合成成功，播放视频
//                self.playVideo(videoURL: videoURL, playbackRate: playbackRate)
//            } else {
//                // 视频合成失败，处理错误
//                if let error = videoExport?.error {
//                    print("视频合成失败：\(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    
//    func playVideo(videoURL: URL, playbackRate: Float) {
//        let player = AVPlayer(url: videoURL)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
////        playerViewController.player?.playbackRate = playbackRate
//        
//        // 在当前视图控制器中显示视频播放器
//        present(playerViewController, animated: true) {
//            playerViewController.player?.play()
//        }
//    }
    
    
}
