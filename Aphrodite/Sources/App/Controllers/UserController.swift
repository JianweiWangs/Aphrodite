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
            return try req.view().render("userview", data)
        }
    }
    static func create(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap {
            return $0.save(on: req).map { _ in
                return req.redirect(to: "users")
            }
        }
    }
}
