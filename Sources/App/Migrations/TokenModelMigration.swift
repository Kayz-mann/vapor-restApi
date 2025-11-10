//
//  File.swift
//  
//
//  Created by Balogun Kayode on 22/08/2024.
//

import Foundation
import Fluent
import Vapor

struct TokenModelMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(TokenModel.schema)
            .id()
            .field("value", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .field("expires_at", .datetime, .required)
            .unique(on: "value")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(TokenModel.schema).delete()
    }
}

//struct TokenModelMigration: AsyncMigration {
//    let keys = TokenModel.FieldKeys.self
//    let schema = TokenModel.schema
//    
//    func prepare(on database: any Database) async throws {
//        try await database.schema(schema)
//            .id()
//            .field(keys.value, .string)
//            .field(keys.userId, .uuid)
//            .create()
//    }
//    
//    func revert(on database: Database) async throws {
//        try await database.schema(schema).delete()
//    }
//}
