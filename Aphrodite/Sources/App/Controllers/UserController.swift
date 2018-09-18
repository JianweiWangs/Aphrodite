//
//  UserController.swift
//  App
//
//  Created by Wang Jianwei on 2018/9/9.
//
import Vapor
import FluentSQL
import Crypto

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
    
    static func renderRegister(_ req: Request) throws -> Future<View> {
        return try req.view().render("register")
    }
    
    static func register(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap { user in
            return User.query(on: req).filter(\.email == user.email).first().flatMap { result in
                if let _ = result {
                    return Future.map(on: req) {
                        return req.redirect(to: "/register")
                    }
                }
                user.password = try BCryptDigest().hash(user.password)
                return user.save(on: req).map { _ in
                    return req.redirect(to: "/login")
                }
            }
        }
    }
    
    static func renderLogin(_ req: Request) throws -> Future<View> {
        return try req.view().render("login")
    }
    
    static func login(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap { user in
            return User.authenticate(
                username: user.email,
                password: user.password,
                using: BCryptDigest(),
                on: req
                ).map { user in
                    guard let user = user else {
                        return req.redirect(to: "/login")
                    }
                    try req.authenticateSession(user)
                    return req.redirect(to: "/profile")
            }
        }
    }
    static func profile(_ req: Request) throws -> Future<View> {
        let user = try req.requireAuthenticated(User.self)
        return try req.view().render("profile", user)
    }
    static func logout(_ req: Request) throws -> Future<Response> {
        try req.unauthenticateSession(User.self)
        return Future.map(on: req, {
            return req.redirect(to: "/login")
        })
    }
    
}
