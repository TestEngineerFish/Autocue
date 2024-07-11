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
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.text               = ""
        textView.backgroundColor    = .clear
        textView.textColor          = .white
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
        self.backgroundColor = .blue
        self.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if ConfigModel.share.isMirror {
            textView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    // MARK: ==== Event ====
    func updateContent(_ value: String) {
        textView.font = ConfigModel.share.font
        let mAttrText = NSMutableAttributedString(string: value)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = ConfigModel.share.lineSpacing
        let kernSpacing = ConfigModel.share.kernSpacing
        mAttrText.addAttributes([.kern : kernSpacing,
                                 .foregroundColor : UIColor.white,
                                 .paragraphStyle : paragraphStyle
        ], range: NSRange(location: 0, length: mAttrText.length))
        textView.attributedText = mAttrText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("click event!!!!")
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
        textView.contentOffset = .init(x: 0, y: offsetY + 1)
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

