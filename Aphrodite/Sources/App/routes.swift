import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    router.get("users", use: UserController.read)
    router.post("users", use: UserController.create)
    router.patch("users", User.parameter, use: UserController.update)
    router.delete("users", User.parameter, use: UserController.delete)
}
