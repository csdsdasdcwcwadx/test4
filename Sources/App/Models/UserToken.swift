//
//  File.swift
//  
//
//  Created by 蔡濡安 on 2021/7/19.
//

import Foundation
import Vapor
import Fluent

final class UserToken: Content, Model {
    static let schema: String = "user_tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    // token過期時間
    @Field(key: "expire_time")
    var expireTime: Date?

    // 關聯到User
    @Parent(key: "user_id")
    var user: User

    init() {}

    init(id: UUID? = nil, value: String, expireTime: Date?, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.expireTime = expireTime
        self.$user.id = userID
    }
}

extension UserToken: ModelTokenAuthenticatable {
   
    //Token的欄位
    static var valueKey = \UserToken.$value
    
    //要取對應的User欄位
    static var userKey = \UserToken.$user

    // 驗證，這裡只檢查是否過期
    var isValid: Bool {
        guard let expireTime = expireTime else { return false }
        return expireTime > Date()
    }
}

