//
//  File.swift
//
//
//  Created by Balogun Kayode on 20/08/2024.
//


import Foundation
import Fluent
import Vapor

struct GuideModelMigration: AsyncMigration {
    let schema = GuideModel.schema.self
    let keys = GuideModel.FieldKeys.self
    
    func prepare(on database: any Database) async throws {
        try await database.schema(schema)
        
            .id()
            .field(keys.title, .string)
            .field(keys.description, .string)
            .field(keys.slug, .string)
            .field(keys.headerImage, .string)
            .field(keys.author, .string)
            .field(keys.status, .string)
            .field(keys.price, .string)
            .field(keys.createdAt, .datetime)
            .field(keys.updatedAt, .datetime)
            .field(keys.publishDate, .datetime)
            .field(keys.tags, .array(of: .string))
            .create()

    }
    
    func revert (on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}

