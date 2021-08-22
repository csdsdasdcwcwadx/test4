import Vapor
import Fluent
import FluentPostgresDriver
import FluentPostGIS


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(hostname: "localhost", username: "postgres", password: "", database: "template1"), as: .psql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateInfo())
    app.migrations.add(CreateUserToken())
    app.migrations.add(EnablePostGISMigration())
    app.sessions.use(.fluent)

    
    
    // register routes
    try routes(app)
    
}
