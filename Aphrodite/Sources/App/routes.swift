import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    router.get("users", use: UserController.list)
    router.post("users", use: UserController.create)
    router.post("users", User.parameter, "update", use: UserController.update)
    router.post("users", User.parameter, "delete", use: UserController.delete)
}
