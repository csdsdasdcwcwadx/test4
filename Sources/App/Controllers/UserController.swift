//
//  File.swift
//  
//
//  Created by 蔡濡安 on 2021/6/29.
//

import Foundation
import Vapor
import Fluent
import FluentPostGIS


final class UserController{
    
    func finduser (_ req: Request) throws -> EventLoopFuture<[User]>{
        let user = try req.content.decode(User.Create.self)
        return User.query(on: req.db).filter(\.$account == user.account).all()
    }
    
    func update (_ req: Request) throws -> EventLoopFuture<HTTPStatus>  {
        try User.Create.validate(content: req)
        let user = try req.content.decode(User.Create.self)
        guard user.password == user.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let pass = try Bcrypt.hash(user.password)
        
        return User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.password = pass
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    
    func signup (_ req: Request) throws -> EventLoopFuture<User>{
        
        try User.Create.validate(content: req)

            // 從request body中decode出User.Create
        let newUser = try req.content.decode(User.Create.self)
            // 先檢查密碼是否==確認密碼
        guard newUser.password == newUser.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
            // 將User.Create 轉成 User
        let user = try User(account: newUser.account, password: Bcrypt.hash(newUser.password))
            // 儲存User並回傳
        return user.save(on: req.db).map { user }
    }
    
    func login(_ req: Request) throws -> EventLoopFuture<UserToken>{
        let user = try req.auth.require(User.self)
        // 驗證過了就產生Token
        let token = try user.generateToken()
        return token.save(on: req.db).map { token }
    }
    
    func getperinfo(_ req: Request) throws -> EventLoopFuture<[MyInfoResult]>{
        let user = try req.auth.require(User.self)
        return Info.query(on: req.db).filter(\.$user.$id == user.id!).all().map {
            $0.map { MyInfoResult(id: $0.id!, name: $0.name, account: $0.account, picture: $0.picture, age: $0.age, birth: $0.birth, city: $0.city, hobby: $0.hobby) }
        }
    }
    
    func logout(_ req: Request) throws -> EventLoopFuture<HTTPStatus>{
        UserToken.find(req.parameters.get("user_tokensId"), on: req.db).unwrap(or: Abort(.notFound))
            .flatMap{
                $0.delete(on: req.db)
            }.transform(to: .ok)
    }
}


