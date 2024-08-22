//
//  File.swift
//
//
//  Created by Balogun Kayode on 20/08/2024.
//


import Foundation
import Fluent
import Vapor

struct CourseModelMigration: AsyncMigration {
    let schema = CourseModel.schema
    let keys = CourseModel.FieldKeys.self
    
    func prepare(on database: any Database) async throws {
        try await database.schema(schema)
            .id()
            .field(keys.title, .string)
            .field(keys.description, .string)
            .field(keys.slug, .string)
            .field(keys.article, .string)
            .field(keys.topHexColor, .string)
            .field(keys.bottomHexColor, .string)
            .field(keys.syllabus, .string)
            .field(keys.headerImage, .string)
            .field(keys.author, .string)
            .field(keys.status, .string)
            .field(keys.price, .string)
            .field(keys.createdAt, .datetime)
            .field(keys.updatedAt, .datetime)
            .field(keys.publishDate, .datetime)
            .field(keys.tags, .array(of: .string))
            .field(keys.assets, .string)  // Adding the assets field
            .unique(on: keys.syllabus)
            .unique(on: keys.assets)  // Applying unique constraint on the assets field
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}

