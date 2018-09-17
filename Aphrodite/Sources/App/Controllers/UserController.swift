//
//  UserController.swift
//  App
//
//  Created by Wang Jianwei on 2018/9/9.
//
import Vapor

final class UserController {
    static func users(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    static func addUser(_ req: Request) throws -> Future<[String: String]> {
        return try req.content.decode(User.self).flatMap {
            return $0.save(on: req).map { _ in
                return ["code": "200"]
            }
        }
    }
    static func view(_ req: Request) throws -> Future<View> {
        return try req.view().render("register")
    }
}
