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
    let keys = TokenModel.FieldKeys.self
    let schema = TokenModel.schema
    
    func prepare(on database: any Database) async throws {
        try await database.schema(schema)
            .id()
            .field(keys.value, .string)
            .field(keys.userId, .uuid)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
