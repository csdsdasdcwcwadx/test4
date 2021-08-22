//
//  File.swift
//  
//
//  Created by 蔡濡安 on 2021/7/2.
//

import Foundation
import Fluent
import Vapor
import FluentPostgresDriver


final class User:Model,Content{
    static let schema = "user"
    
    @ID(key: .id)
    var id:UUID?
    
    @Field(key:"帳號")
    var account:String
    
    @Field(key: "密碼")
    var password:String
    
    @Children(for: \.$user)
    var perinfo: [Info]
    
    
    init() {}
    
    init(id: UUID?=nil, account:String, password:String){
        self.id=id
        self.account=account
        self.password=password
        
    }    
}

extension User: ModelAuthenticatable {

    
    // 要取帳號的欄位
    static var usernameKey: KeyPath<User, Field<String>> = \User.$account
    
    // 要取雜湊密碼的欄位
    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$password

    // 驗證
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension User {
    struct Create: Content {
        var account: String
        var password: String
        var confirmPassword: String // 確認密碼
    }
}

extension User.Create: Validatable {
    
    static func validations(_ validations: inout Validations) {
        
        validations.add("account", as: String.self, is: .count(10...10))
        // password需為8~16碼
        validations.add("password", as: String.self, is: .count(8...16))
    }
}





extension User {
    func generateToken() throws -> UserToken {
        // 產生一組新Token, 有效期限為一天
        let calendar = Calendar(identifier: .gregorian)
        let expiryDate = calendar.date(byAdding: .day, value: 1, to: Date())

        return try UserToken(value: [UInt8].random(count: 16).base64, expireTime: expiryDate, userID: self.requireID())
    }
}


