//
//  BPIMDBOperator.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import FMDB

protocol BPIMDBProtocol {
    // 单例操作对象
    static var `default`: BPIMDBOperator { get }

    // MARK: 操作
    /// 保存
    func saveCue(model: BPCueModel) -> Bool
    /// 查询
    func selectCue(id: String) -> BPCueModel?
    /// 插入
    func insertCue(model: BPCueModel) -> Bool
    /// 更新
    func updateCue(model: BPCueModel) -> Bool
    /// 查询所有
    func selectAllCue() -> [BPCueModel]
}

extension BPIMDBProtocol {
    static var `default`: BPIMDBOperator { return BPIMDBOperator() }
}

class BPIMDBOperator: BPIMDBProtocol, BPDatabaseProtocol {

    // MARK: ==== Session ====
    
    func saveCue(model: BPCueModel) -> Bool {
        if let _ = selectCue(id: model.id) {
            return updateCue(model: model)
        } else {
            return insertCue(model: model)
        }
    }
    
    func selectCue(id: String) -> BPCueModel? {
        var model: BPCueModel?
        let sql = BPSQLManager.CueOperate.selectCue.rawValue
        guard let result = self.normalRunner.executeQuery(sql, withArgumentsIn: []) else {
            return model
        }
        while result.next() {
            model = self.transformCueModel(result: result)
            break
        }
        return model
    }
    
    @discardableResult
    func insertCue(model: BPCueModel) -> Bool {
        let values = [model.id,
                      model.title,
                      model.content] as [Any]
        let sql    = BPSQLManager.CueOperate.insertCue.rawValue
        let result = self.normalRunner.executeUpdate(sql, withArgumentsIn: values)
        return result
    }

    @discardableResult
    func updateCue(model: BPCueModel) -> Bool {
        let params = [model.updateTime,
                      model.title,
                      model.content,
                      model.id] as [Any]
        let sql    = BPSQLManager.CueOperate.updateCue.rawValue
        let result = self.normalRunner.executeUpdate(sql, withArgumentsIn: params)
        return result
    }
    
    func selectAllCue() -> [BPCueModel] {
        var modelList = [BPCueModel]()
        let sql = BPSQLManager.CueOperate.selectAllCue.rawValue
        guard let result = self.normalRunner.executeQuery(sql, withArgumentsIn: []) else {
            return modelList
        }
        while result.next() {
            let model = self.transformCueModel(result: result)
            modelList.append(model)
        }
        return modelList
    }

    // MARK: ==== Tools ====
    private func transformCueModel(result: FMResultSet) -> BPCueModel {
        var model = BPCueModel()
        model.id         = result.string(forColumn: "cue_id") ?? "0"
        model.createTime = result.date(forColumn: "create_time") ?? Date()
        model.updateTime = result.date(forColumn: "update_time") ?? Date()
        model.title      = result.string(forColumn: "title") ?? ""
        model.content    = result.string(forColumn: "content") ?? ""
        return model
    }

}
