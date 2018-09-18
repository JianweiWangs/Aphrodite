import Vapor
import Authentication
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("users", use: UserController.users)
    router.post("users", use: UserController.addUser)
    router.get("register", use: UserController.renderRegister)
    router.post("register", use: UserController.register)
    router.get("login", use: UserController.renderLogin)
    
    let authSessionRouter = router.grouped(User.authSessionsMiddleware())
    authSessionRouter.post("login", use: UserController.login)

    
    let protectedRouter = authSessionRouter.grouped(RedirectMiddleware<User>(path: "/login"))
    protectedRouter.get("profile", use: UserController.profile)
    
    router.get("logout", use: UserController.logout)
}
