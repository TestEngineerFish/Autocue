//
//  SubtitlesView.swift
//  Autocue
//
//  Created by 老沙 on 2023/8/16.
//

import UIKit

protocol CustomPipViewProtocol: NSObjectProtocol {
    func start()
    func pause()
}

class SubtitlesView: UIView, CustomPipViewProtocol {
    
    // timer
    private var displayerLink: CADisplayLink?
    private var offsetStep: CGFloat = 1
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.text               = ""
        textView.backgroundColor    = .black
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: ==== Init ====
    private func initUI() {
        self.backgroundColor = .black
        self.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: ==== Event ====
    func updateContent(_ value: String) {
        self.offsetStep             = ConfigModel.share.speedScale * 5
        let mAttrText               = NSMutableAttributedString(string: value)
        let paragraphStyle          = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing  = ConfigModel.share.lineScale * 10
        let kernSpacing             = ConfigModel.share.kernScale * 10
        let fontSize                = UIFont.systemFont(ofSize: ConfigModel.share.fontScale * 30)
        mAttrText.addAttributes([.kern              : kernSpacing,
                                 .foregroundColor   : UIColor.white,
                                 .paragraphStyle    : paragraphStyle,
                                 .font              : fontSize,
        ], range: NSRange(location: 0, length: mAttrText.length))
        self.textView.attributedText = mAttrText
        if ConfigModel.share.isMirror {
            textView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    func syncStyle() {
        updateContent(textView.attributedText.string)
    }

    // 开始滚动
    func startTimer() {
        guard self.displayerLink?.isPaused ?? true else {
            return
        }
        stopTimer()
        displayerLink = CADisplayLink.init(target: self, selector: #selector(move))
        displayerLink?.preferredFramesPerSecond = 30
        let currentRunloop = RunLoop.current
        // 常驻线程
        currentRunloop.add(Port(), forMode: .default)
        displayerLink?.add(to: currentRunloop, forMode: .default)
    }
    
    // 停止滚动
    func stopTimer() {
        if displayerLink != nil {
            displayerLink?.invalidate()
            displayerLink = nil
        }
    }
    
    @objc private func move() {
        let offsetY = textView.contentOffset.y
        textView.contentOffset = .init(x: 0, y: offsetY + self.offsetStep)
        if textView.contentOffset.y > textView.contentSize.height {
            textView.contentOffset = .zero
        }
    }
    
    // MARK: ==== CustomPipViewProtocol ====
    func start() {
        self.startTimer()
    }
    
    func pause() {
        self.stopTimer()
    }
    
}

