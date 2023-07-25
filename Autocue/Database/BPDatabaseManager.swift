//
//  BPDatabaseManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import FMDB

public enum BPDatabaseType: String {
    /// 普通数据库
    case cue = "cue.db"
}

public enum BPSQLError: Error {
    case CreateDatabaseError
    case CreateTableError
    case ExecuteSQLError
}

public class BPDatabaseManager {

    /// FMDB全局单例
    public static let `default` = BPDatabaseManager()

    /// 存储所有的执行器
    private var runners = [BPDatabaseType : FMDatabase]()

    /// 根据数据源类型, 返回对应的执行器
    ///
    /// - Parameter type: 数据源类型
    /// - Returns: FMDB数据库执行器
    public func createRunner(type: BPDatabaseType) -> FMDatabase {
        switch type {
        case .cue:
            return try! cueRunner()
        }
    }

    // MARK: 构造执行器

    /// 构造普通数据库
    ///
    /// - Returns: 普通数据的执行器
    /// - Throws: 构造失败异常
    private func cueRunner() throws -> FMDatabase {
        let filePath = self.dbFilePath(fileName: BPDatabaseType.cue.rawValue)
        print(filePath)
        return try createRunner(type: .cue, filePath: filePath, sqls: BPSQLManager.createCueTables)
    }


    /// 构造数据库地址
    ///
    /// - Parameter fileName: 数据库名称
    /// - Returns: 数据地址
    func dbFilePath(fileName: String) -> String {
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if documentPath == nil {
            documentPath = NSHomeDirectory() + "/Documents"
        }
        let dbFilePath = String(format: "%@/db/", documentPath!)
        if !FileManager.default.fileExists(atPath: dbFilePath) {
            do {
                try FileManager.default.createDirectory(atPath: dbFilePath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                print("Create DB directory fail")
            }
        }
        return dbFilePath + fileName
    }


    /// 创建数据库,缓存中存在则直接读取缓存数据
    ///
    /// - Parameters:
    ///   - type: 数据库类型
    ///   - filePath: 数据库地址
    ///   - sqls: 数据库初始化函数
    /// - Returns: 数据库执行器
    /// - Throws: 创建数据异常
    private func createRunner(type: BPDatabaseType, filePath: String, sqls: [String]) throws -> FMDatabase {
        if let runner = runners[type] { return runner }

        let runner = FMDatabase(path: filePath)
        guard runner.open() else {
            print(String(format: "Error: open database failed, filetPath: %@", filePath))
            throw BPSQLError.CreateDatabaseError
        }
        for sql in sqls {
            let success = runner.executeStatements(sql)
            if !success {
                print(String(format: "Error: execute sql: %@, failed error message: %@", sql, runner.lastErrorMessage()))
            }
        }
        // 添加到缓存
        runners[type] = runner
        return runner
    }
}
