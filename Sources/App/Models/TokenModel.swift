//
//  File.swift
//  
//
//  Created by Balogun Kayode on 22/08/2024.
//

//
// TokenModel.swift
//

//
//  TokenModel.swift
//
//  Created by Balogun Kayode on 22/08/2024.
//

import Foundation
import Vapor
import Fluent

final class TokenModel: Model, Content {
    static let schema = "tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "user_id")
    var user: UserModel
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Field(key: "expires_at")  // Changed from @Timestamp to @Field
    var expiresAt: Date
    
    init() {}
    
    init(id: UUID? = nil, value: String, userID: UUID, expiresAt: Date? = nil) {
        self.id = id
        self.value = value
        self.$user.id = userID
        self.expiresAt = expiresAt ?? Date().addingTimeInterval(3600 * 24) // 24 hours from now
    }
    
    static func generate(for user: UserModel) throws -> TokenModel {
        let random = [UInt8].random(count: 16).base64
        return TokenModel(value: random, userID: try user.requireID())
    }
}

// MARK: - Authentication
extension TokenModel: ModelTokenAuthenticatable {
    static let valueKey = \TokenModel.$value
    static let userKey = \TokenModel.$user
    
    var isValid: Bool {
        expiresAt > Date()
    }
}

// MARK: - Migration
struct CreateTokenMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .field("expires_at", .datetime, .required)  // Made expires_at required
            .unique(on: "value")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens").delete()
    }
}