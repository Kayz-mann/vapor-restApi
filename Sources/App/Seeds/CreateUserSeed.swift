//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Vapor
import Fluent

struct CreateUserSeed: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        let admin = UserModel(username: "Kayzmann", email:"kay@email.com", password: try Bcrypt.hash("Password@123"), role: RoleEnum.admin.rawValue, createdAt: Date(), updatedAt: Date())
        
        try await admin.create(on: database)
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await UserModel.query(on: database).delete()
    }

}
