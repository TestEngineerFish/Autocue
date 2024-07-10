//
//  ConfigViewController.swift
//  Autocue
//
//  Created by 老沙 on 2023/8/16.
//

import UIKit
import SnapKit

class ConfigViewController: UIViewController {
    private var reviewView: UIView = UIView()
    private let testModel: BPCueModel = {
        var model = BPCueModel()
        model.title   = "title"
        model.content =
        """
        
        在数字化时代，直播已成为人们分享、交流和娱乐的重要方式。无论是社交媒体平台还是专业直播平台，都充满了各种各样的内容，吸引着来自全球的观众。通过直播，人们可以实时展示自己的生活、技能和见解。从美食、旅行到电子竞技和知识讲座，直播涵盖了几乎所有领域。
        
        直播不仅仅是一种娱乐方式，也成为了营销和教育的有效工具。许多企业利用直播展示新产品，与消费者互动，实时解答疑问。教育机构利用直播开设在线课程，让学生足不出户也能获取知识。此外，直播也促进了粉丝与偶像之间更紧密的联系，粉丝可以通过直播与明星互动，感受到身临其境的亲近感。

        然而，直播也面临着一些问题，如内容审核、隐私保护等。不良内容的直播可能会对观众造成负面影响，因此平台需要加强管理和监管。同时，直播也需要注意个人隐私，确保用户信息不被滥用。

        总之，直播已经在我们的生活中扮演着重要角色，无论是为了娱乐、教育还是商业目的，它都在连接人与人之间架起了一座数字的桥梁。
        
        """
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        PlayManager.share.play()
    }
    
    // MARK: ==== Init ====
    private func initUI() {
//        self.reviewView = PlayManager.share.getPlayView()
//        self.view.addSubview(reviewView)
//        self.reviewView.backgroundColor = .red
//        self.reviewView.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 200, height: 200))
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(120)
//        }
    }
}
