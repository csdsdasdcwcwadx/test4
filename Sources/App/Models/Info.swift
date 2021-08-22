//
//  File.swift
//  
//
//  Created by 蔡濡安 on 2021/8/19.
//

import Foundation
import Fluent
import Vapor
import FluentPostgresDriver
import FluentPostGIS

final class Info:Model,Content{
    static let schema = "info"
    
    @ID(key: .id)
    var id:UUID?
    
    @Field(key: "姓名")
    var name: String
    
    @Field(key: "IG帳號")
    var account: String
    
    @Field(key: "頭像")
    var picture: String
    
    @Field(key: "年紀")
    var age: String
    
    @Field(key: "生日")
    var birth: String
    
    @Field(key: "居住城市")
    var city: String
    
    @Field(key: "興趣")
    var hobby : String
    
    @Field(key:"位置")
    var location: GeometricPoint2D
    
    @Parent(key: "user_id")
    var user: User

    init(){}
    
    init(id:UUID?=nil, name:String, account:String, picture:String ,age:String, birth:String,location: GeometricPoint2D , city:String, hobby:String, userId:UUID){
        self.id=id
        self.name=name
        self.account=account
        self.picture=picture
        self.age=age
        self.birth=birth
        self.location=location
        self.city=city
        self.hobby=hobby
        self.$user.id=userId
    }
}

extension Info{
    struct UserLocation: Content {
        var id: UUID?
        var name: String
        var account: String
        var picture: String
        var age: String
        var birth: String
        var city: String
        var hobby : String
        var latitude : Double
        var longitude : Double
        var user: User.IDValue?
    }
}

struct MyInfoResult: Content {
    let id: UUID
    let name: String
    let account: String
    let picture: String
    let age: String
    let birth: String
    let city: String
    let hobby : String
    var user: User.IDValue?
}

