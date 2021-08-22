//
//  File.swift
//  
//
//  Created by 蔡濡安 on 2021/7/19.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateUserToken:Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user_tokens")
            .id()
            .field("value", .string, .required)
            .field("expire_time", .date)
            .field("user_id", .uuid, .references("user", "id"))
            .unique(on: "value")
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user_tokens").delete()
    }
}
