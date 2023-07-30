//
//  BPCueModel.swift
//  Autocue
//
//  Created by 老沙 on 2023/7/23.
//

import Foundation
import ObjectMapper

struct BPCueModel: Mappable {
    var id: String
    var createTime: Date = Date()
    var updateTime: Date = Date()
    var title: String = ""
    var content: String = ""
    
    init() {
        id = "\(Date().timeIntervalSince1970)"
    }
    init?(map: ObjectMapper.Map) {
        id = "\(Date().timeIntervalSince1970)"
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id          <- map["id"]
        createTime  <- map["createTime"]
        updateTime  <- map["updateTime"]
        title       <- map["title"]
        content     <- map["content"]
    }
    
    
}
