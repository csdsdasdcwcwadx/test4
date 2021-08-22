//
//  File.swift
//  
//
//  Created by 蔡濡安 on 2021/8/8.
//

import Foundation
import Fluent
import FluentPostgresDriver
import FluentPostGIS

struct CreateInfo: Migration{
    func prepare(on database: Database)->EventLoopFuture<Void>{
        database.schema("info")
            .id()
            .field("IG帳號", .string, .required)
            .field("姓名", .string, .required)
            .field("年紀", .string)
            .field("生日", .string)
            .field("居住城市", .string)
            .field("興趣", .string)
            .field("頭像",.string)
            .field("位置", GeometricPoint2D.dataType)
            .field("user_id",.uuid ,.references("user","id"))
            .create() 
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("info").delete()
    }
}
