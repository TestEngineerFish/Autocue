//
//  BPCueModel.swift
//  Autocue
//
//  Created by 老沙 on 2023/7/23.
//

import Foundation
import ObjectMapper

struct BPCueModel: Mappable {
    var id: String = "0"
    var createTime: Date = Date()
    var updateTime: Date = Date()
    var title: String = ""
    var content: String = ""
    
    init() {}
    init?(map: ObjectMapper.Map) {}
    
    mutating func mapping(map: ObjectMapper.Map) {
        id          <- map["id"]
        createTime  <- map["createTime"]
        updateTime  <- map["updateTime"]
        title       <- map["title"]
        content     <- map["content"]
    }
    
    
}
