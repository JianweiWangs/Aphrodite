//
//  UserController.swift
//  App
//
//  Created by Wang Jianwei on 2018/9/9.
//
import Vapor

final class UserController {
    static func read(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    static func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap {
            return $0.save(on: req)
        }
    }
    static func update(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self).flatMap { user in
            return try req.content.decode(User.self).flatMap { newUser in
                user.username = newUser.username
                return user.save(on: req)
            }
        }
    }
    static func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            user.delete(on: req)
        }.transform(to: .ok)
    }
}
