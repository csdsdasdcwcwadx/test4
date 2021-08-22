//
//  File.swift
//  
//
//  Created by 蔡濡安 on 2021/7/13.
//

import Foundation
import Vapor
import Fluent
import FluentPostGIS

final class InformationController{
    
    func create (_ req: Request) throws -> EventLoopFuture<Info>{
        
        let perinfo = try req.content.decode(Info.UserLocation.self)
        let gis = GeometricPoint2D(x: perinfo.longitude, y: perinfo.latitude)
        let info = Info(name: perinfo.name, account: perinfo.account, picture: perinfo.picture, age: perinfo.age, birth: perinfo.birth, location: gis, city: perinfo.city, hobby: perinfo.hobby, userId: perinfo.user!)
        return info.save(on: req.db).map {info}
    }
    
    func update (_ req: Request) throws -> EventLoopFuture<HTTPStatus>  {
        let information = try req.content.decode(Info.UserLocation.self)
        return Info.find(information.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.name=information.name
                $0.account=information.account
                $0.picture=information.picture
                $0.age=information.age
                $0.birth=information.birth
                $0.city=information.city
                $0.hobby=information.hobby
                return $0.update(on: req.db).transform(to: .ok)
            }
    }

    func otherperinfo(_ req: Request) throws -> EventLoopFuture<[MyInfoResult]>{
        guard let perinfo = req.parameters.get("userId", as: UUID.self) else{
            throw Abort(.notFound)
        }
        return Info.query(on: req.db).filter(\.$user.$id, .equal, perinfo).all().map {
            $0.map { MyInfoResult(id: $0.id!, name: $0.name, account: $0.account, picture: $0.picture, age: $0.age, birth: $0.birth, city: $0.city, hobby: $0.hobby) }
        }
    }
    
    
    
    func changelocation (_ req: Request) throws ->EventLoopFuture<HTTPStatus>{ //
        let information = try req.content.decode(Info.UserLocation.self)
        return Info.find(information.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.location = GeometricPoint2D(x: information.longitude, y: information.latitude)
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    func gis (_ req:Request) throws -> EventLoopFuture<[MyInfoResult]> {
        
        let coordinate = try req.content.decode(Info.UserLocation.self)
        let location = GeometricPoint2D(x: coordinate.longitude, y: coordinate.latitude)
        return Info.query(on: req.db).filterGeometryDistanceWithin(\.$location, location,0.01).all().map {
            $0.map { MyInfoResult(id: $0.id!, name: $0.name, account: $0.account, picture: $0.picture, age: $0.age, birth: $0.birth, city: $0.city, hobby: $0.hobby) }
        }
    }
}
