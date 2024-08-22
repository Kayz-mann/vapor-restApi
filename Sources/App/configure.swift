import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("5432").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "elearningdb",
        password: Environment.get("DATABASE_PASSWORD") ?? "tetraoxochamber4",
        database: Environment.get("DATABASE_NAME") ?? "elearningdb",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    //setup migration
    app.migrations.add(UserModelMigration())
    app.migrations.add(CourseModelMigration())
    app.migrations.add(SessionModelMigration())
    app.migrations.add(GuideModelMigration())
    app.migrations.add(ArticleModelMigration())
    app.migrations.add(TokenModelMigration())
    
    //Seed Setup
    app.migrations.add(CreateUserSeed())
    
    try app.autoMigrate().wait()
    
    
    // register routes
    try routes(app)
    
    print(Environment.get("DATABASE_HOST")) // Should print "localhost"
    print(Environment.get("DATABASE_USERNAME")) // Should print "elearningDB"

}
