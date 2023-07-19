import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    private var playerViewController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        playButton.setTitle("播放视频", for: .normal)
        playButton.setTitleColor(.blue, for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        playButton.center = view.center
        view.addSubview(playButton)
    }
    
    @objc func playButtonTapped() {
        let text = "这是一个示例文本"
        let duration: TimeInterval = 10
        
        composeVideoWithText(text: text, duration: duration)
    }
    
    func composeVideoWithText(text: String, duration: TimeInterval) {
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
                self.playVideo(videoURL: videoURL)
            } else {
                // 视频合成失败，处理错误
                if let error = exportSession.error {
                    print("视频合成失败：\(error.localizedDescription)")
                }
            }
        }
    }

    func playVideo(videoURL: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.playerViewController = AVPlayerViewController()
            let player = AVPlayer(url: videoURL)
            self.playerViewController?.player = player
            
            // 在当前视图控制器中显示视频播放器
            self.present(self.playerViewController!, animated: true) {
                player.play()
            }
        }
    }
}
