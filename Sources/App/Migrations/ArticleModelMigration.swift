//
//  File.swift
//  
//
//  Created by Balogun Kayode on 20/08/2024.
//


import Foundation
import Fluent
import Vapor

struct ArticleModelMigration: AsyncMigration {
    let schema = ArticleModel.schema.self
    let keys = ArticleModel.FieldKeys.self
    
    func prepare(on database: any Database) async throws {
        try await database.schema(schema)
        
            .id()
            .field(keys.title, .string)
            .field(keys.slug, .string)
            .field(keys.excerp, .string)
            .field(keys.content, .string)
            .field(keys.guide, .uuid)
            .field(keys.headerImage, .string)
            .field(keys.author, .string)
            .field(keys.status, .string)
            .field(keys.price, .string)
            .field(keys.role, .string)
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

