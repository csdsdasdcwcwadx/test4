//
//  File.swift
//  
//
//  Created by 蔡濡安 on 2021/7/13.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateUser:Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user")
            .id()
            .field("帳號", .string, .required)
            .field("密碼", .string, .required)
            .unique(on: "帳號")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user").delete()
    }
}
