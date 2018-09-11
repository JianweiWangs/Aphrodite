import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    
    try services.register(FluentPostgreSQLProvider())
    let postgresqlConfig = PostgreSQLDatabaseConfig(
        hostname: "127.0.0.1",
        port: 5432,
        username: "wangjianwei",
        database: "wfdb",
        password: nil
    )
    services.register(postgresqlConfig)
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)

}
