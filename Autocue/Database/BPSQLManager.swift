//
//  BPSQLManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

public struct BPSQLManager {
    
    /// 初始化IM系统数据时,构造的表结构
    public static let createCueTables = [
        CreateCueTableSQLs.cue.rawValue]
    
    // MARK: 创建表
    /// 创建需要的表结构
    enum CreateCueTableSQLs: String {
        case cue =
        """
        CREATE TABLE IF NOT EXISTS cue(
        serial integer primary key,
        cue_id text,
        create_time integer NOT NULL DEFAULT(datetime('now', 'localtime')),
        update_time integer NOT NULL DEFAULT(datetime('now', 'localtime')),
        title text,
        content text,
        extend blob);
        """
    }
    
    // MARK: IM表
    // TODO: ==== Session ====
    enum CueOperate: String {
        case selectAllCue =
        """
        SELECT * FROM cue
        ORDER by COALESCE(cue_id, 0) DESC, update_time DESC
        """
        case selectCue =
        """
        SELECT * FROM cue
        WHERE cue_id = ?
        """
        case insertCue =
        """
        INSERT INTO cue(
            create_time,
            update_time, 
            cue_id,
            title,
            content)
        VALUES (?,?,?,?,?);
        """
        case updateCue =
        """
        UPDATE cue
        SET update_time = ?,
            title = ?,
            content = ?
        WHERE cue_id = ?
        """
        case deleteSession =
        """
        DELETE FROM cue
        WHERE cue_id = ?
        """
        case deleteAllSession =
        """
        DELETE FROM cue
        """
    }
}
