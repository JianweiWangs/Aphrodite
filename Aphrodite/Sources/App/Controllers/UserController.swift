//
//  UserController.swift
//  App
//
//  Created by Wang Jianwei on 2018/9/9.
//
import Vapor

final class UserController {
    
    static func list(_ req: Request) throws -> Future<View> {
        return User.query(on: req).all().flatMap { users in
            let data = ["userlist": users]
            return try req.view().render("crud", data)
        }
    }
    
    static func create(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap {
            return $0.save(on: req).map { _ in
                return req.redirect(to: "/users")
            }
        }
    }
    
    static func update(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(User.self).flatMap { user in
            return try req.content.decode(User.self).flatMap {
                newUser in
                user.username = newUser.username
                return user.save(on: req).map { _ in
                    return req.redirect(to: "/users")
                }
            }
        }
    }
    
    static func delete(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req).map { _ in
                return req.redirect(to: "/users")
            }
        }
    }
    
}

struct UserForm: Content {
    var username: String
}
