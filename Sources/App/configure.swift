import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import Logging


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.logger.logLevel = .debug


    do {
        try app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "elearningdb",
            password: Environment.get("DATABASE_PASSWORD") ?? "tetraoxochamber4",
            database: Environment.get("DATABASE_NAME") ?? "elearningdb",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
        print("Database connection successful")
    } catch {
        print("Failed to connect to database: \(error)")
        throw error
    }
    
    struct GlobalErrorMiddleware: Middleware {
        func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
            return next.respond(to: request).flatMapError { error in
                print("Unhandled error: \(error)")
                return request.eventLoop.future(error: error)
            }
        }
    }

    // In configure.swift
    app.middleware.use(GlobalErrorMiddleware())

    //setup migration
    app.migrations.add(UserModelMigration())
    app.migrations.add(CourseModelMigration())
    app.migrations.add(SessionModelMigration())
    app.migrations.add(GuideModelMigration())
    app.migrations.add(ArticleModelMigration())
    app.migrations.add(TokenModelMigration())
    app.migrations.add(CreateDatabaseQueryTestResult())
    
    //Seed Setup
//    app.migrations.add(CreateUserSeed())
    
//    try await app.autoMigrate().get()
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
    
}
