//
//  File.swift
//
//
//  Created by Balogun Kayode on 20/08/2024.
//

import Foundation
import Fluent
import Vapor

struct UserModelMigration: AsyncMigration {
    let schema = UserModel.schema.self
    let keys = UserModel.FieldKeys.self
    
    func prepare(on database: any Database) async throws {
        try await database.schema(schema)
        
            .id()
            .field(keys.name, .string)
            .field(keys.lastName, .string)
            .field(keys.userName, .string)
            .field(keys.email, .string)
            .field(keys.password, .string)
            .field(keys.city, .string)
            .field(keys.address, .string)
            .field(keys.postalcode, .string)
            .field(keys.country, .string)
            .field(keys.role, .string)
            .field(keys.subscriptionIsActiveTill, .datetime)
            .field(keys.myCourses, .array(of: .uuid))
            .field(keys.bio, .string)
            .field(keys.createdAt, .datetime)
            .field(keys.updatedAt, .datetime)
            .unique(on: keys.email)
            .unique(on: keys.userName)
            .create()

    }
    
    func revert (on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
