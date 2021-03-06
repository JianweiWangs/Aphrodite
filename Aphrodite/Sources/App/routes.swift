import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    router.get("users", use: UserController.users)
    router.post("addUser", use: UserController.addUser)
    
}
