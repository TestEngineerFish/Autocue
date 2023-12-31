//
//  HomeCollectionCell.swift
//  Autocue
//
//  Created by 老沙 on 2023/7/30.
//

import Foundation
import UIKit
import SnapKit

class HomeCollectionCell: UICollectionViewCell {
    var model: BPCueModel?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
        self.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== Init ====
    private func initUI() {
        layer.cornerRadius = 15
        layer.masksToBounds = true
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(timeLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
        }
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(10)
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15).priority(1000)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(20)
            make.top.greaterThanOrEqualTo(contentLabel.snp_bottomMargin).offset(5).priority(1000)
        }
    }
    
    
    // MARK: ==== Event ====
    func setData(model: BPCueModel, isSelected: Bool) {
        self.model          = model
        titleLabel.text     = model.title
        contentLabel.text   = model.content
        timeLabel.text      = model.updateTime.formatIMMessageTime()
        if isSelected {
            layer.borderColor   = UIColor.orange.cgColor
            layer.borderWidth   = 2
            backgroundColor     = .white
        } else {
            layer.borderColor   = UIColor.clear.cgColor
            layer.borderWidth   = 0
            backgroundColor     = .orange
        }
    }
}
