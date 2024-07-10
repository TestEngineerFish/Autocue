//
//  SubtitlesView.swift
//  Autocue
//
//  Created by 老沙 on 2023/8/16.
//

import UIKit

class SubtitlesView: UIView {
    
    // timer
    private var displayerLink: CADisplayLink?
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.text               = ""
        textView.backgroundColor    = .clear
        textView.textColor          = .white
        textView.font               = .systemFont(ofSize: 16)
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
        self.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: ==== Event ====
    func updateContent(_ value: String) {
        textView.text = value
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("click event!!!!")
    }
    
    // 开始滚动
    func startTimer() {
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
    
}

