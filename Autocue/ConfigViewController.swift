//
//  ConfigViewController.swift
//  Autocue
//
//  Created by 老沙 on 2023/8/16.
//

import UIKit
import SnapKit

import UIKit

class ConfigViewController: AtViewController {
    
    private let testContent: String = """
            
            在数字化时代，直播已成为人们分享、交流和娱乐的重要方式。无论是社交媒体平台还是专业直播平台，都充满了各种各样的内容，吸引着来自全球的观众。通过直播，人们可以实时展示自己的生活、技能和见解。从美食、旅行到电子竞技和知识讲座，直播涵盖了几乎所有领域。
            
            直播不仅仅是一种娱乐方式，也成为了营销和教育的有效工具。许多企业利用直播展示新产品，与消费者互动，实时解答疑问。教育机构利用直播开设在线课程，让学生足不出户也能获取知识。此外，直播也促进了粉丝与偶像之间更紧密的联系，粉丝可以通过直播与明星互动，感受到身临其境的亲近感。
            
            然而，直播也面临着一些问题，如内容审核、隐私保护等。不良内容的直播可能会对观众造成负面影响，因此平台需要加强管理和监管。同时，直播也需要注意个人隐私，确保用户信息不被滥用。
            
            总之，直播已经在我们的生活中扮演着重要角色，无论是为了娱乐、教育还是商业目的，它都在连接人与人之间架起了一座数字的桥梁。
            
            """
    // UI Elements
    let subtitleView = SubtitlesView()
    let fontSlider = UISlider()
    let kernSpacingSlider = UISlider()
    let lineSpacingSlider = UISlider()
    let scrollSpeedSlider = UISlider()
    let mirrorSwitch = UISwitch()
    let viewDirectionSegmentedControl = UISegmentedControl(items: ["垂直", "水平"])
    let reviewButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subtitleView.updateContent(testContent)
        subtitleView.start()
        // Setup UI
        setupUI()
        loadConfig()
        
        // Add Targets
        fontSlider.addTarget(self, action: #selector(fontSliderChanged(_:)), for: .valueChanged)
        kernSpacingSlider.addTarget(self, action: #selector(kernSpacingSliderChanged(_:)), for: .valueChanged)
        lineSpacingSlider.addTarget(self, action: #selector(lineSpacingSliderChanged(_:)), for: .valueChanged)
        scrollSpeedSlider.addTarget(self, action: #selector(scrollSpeedSliderChanged(_:)), for: .valueChanged)
        mirrorSwitch.addTarget(self, action: #selector(mirrorSwitchChanged(_:)), for: .valueChanged)
        viewDirectionSegmentedControl.addTarget(self, action: #selector(viewDirectionChanged(_:)), for: .valueChanged)
        reviewButton.addTarget(self, action: #selector(reviewAction(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // Setup UI Elements
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [
            createLabelWithSlider(name: "字体大小", slider: fontSlider),
            createLabelWithSlider(name: "文字间距", slider: kernSpacingSlider),
            createLabelWithSlider(name: "行内间距", slider: lineSpacingSlider),
            createLabelWithSlider(name: "滚动速度", slider: scrollSpeedSlider),
            createLabelWithSwitch(name: "是否镜像", switchControl: mirrorSwitch),
            createLabelWithSegmentedControl(name: "画中画方向", segmentedControl: viewDirectionSegmentedControl),
            createLabelWithPreviewControl(name: "预览", button: reviewButton)
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleView)
        view.addSubview(stackView)
        subtitleView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.centerX.equalToSuperview()
            if ConfigModel.share.viewDirection == .vertical {
                make.size.equalTo(CGSize(width: 150, height: 300))
            } else {
                make.size.equalTo(CGSize(width: view.frame.size.width - 30, height: 200))
            }
        }
        stackView.sizeToFit()
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-120)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    // Load Config Values
    private func loadConfig() {
        let config = ConfigModel.share
        fontSlider.value        = Float(config.fontScale)
        kernSpacingSlider.value = Float(config.kernScale)
        lineSpacingSlider.value = Float(config.lineScale)
        scrollSpeedSlider.value = Float(config.speedScale)
        mirrorSwitch.isOn       = config.isMirror
        viewDirectionSegmentedControl.selectedSegmentIndex = config.viewDirection.rawValue
    }
    
    // Create Label with Slider
    private func createLabelWithSlider(name: String, slider: UISlider) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        let label = UILabel()
        label.text = name
        slider.minimumValue = 0
        slider.maximumValue = 1
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(slider)
        return stackView
    }
    
    // Create Label with Switch
    private func createLabelWithSwitch(name: String, switchControl: UISwitch) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        let label = UILabel()
        label.text = name
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(switchControl)
        return stackView
    }
    
    // Create Label with Segmented Control
    private func createLabelWithSegmentedControl(name: String, segmentedControl: UISegmentedControl) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        let label = UILabel()
        label.text = name
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(segmentedControl)
        return stackView
    }
    // Create Label with Segmented Control
    private func createLabelWithPreviewControl(name: String, button: UIButton) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        button.setTitle(name, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orange
        stackView.addArrangedSubview(button)
        return stackView
    }
    
    // Slider Actions
    @objc private func fontSliderChanged(_ sender: UISlider) {
        ConfigModel.share.fontScale = CGFloat(sender.value)
        subtitleView.syncStyle()
    }
    
    @objc private func kernSpacingSliderChanged(_ sender: UISlider) {
        ConfigModel.share.kernScale = CGFloat(sender.value)
        subtitleView.syncStyle()
    }
    
    @objc private func lineSpacingSliderChanged(_ sender: UISlider) {
        ConfigModel.share.lineScale = CGFloat(sender.value)
        subtitleView.syncStyle()
    }
    
    @objc private func scrollSpeedSliderChanged(_ sender: UISlider) {
        ConfigModel.share.speedScale = CGFloat(sender.value)
        subtitleView.syncStyle()
    }
    
    // Switch Action
    @objc private func mirrorSwitchChanged(_ sender: UISwitch) {
        ConfigModel.share.isMirror = sender.isOn
        subtitleView.syncStyle()
    }
    
    // Segmented Control Action
    @objc private func viewDirectionChanged(_ sender: UISegmentedControl) {
        if let viewDirection = ConfigModel.ViewDirection(rawValue: sender.selectedSegmentIndex) {
            ConfigModel.share.viewDirection = viewDirection
            subtitleView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(68)
                make.centerX.equalToSuperview()
                if viewDirection == .vertical {
                    make.size.equalTo(CGSize(width: 150, height: 300))
                } else {
                    make.size.equalTo(CGSize(width: view.frame.size.width - 30, height: 200))
                }
            }
        }
    }
    
    @objc private func reviewAction(_ sender: UIButton) {
        let subtitleView = SubtitlesView()
        subtitleView.updateContent(testContent)
        PlayManager.share.play(subtitleView)
    }
}
