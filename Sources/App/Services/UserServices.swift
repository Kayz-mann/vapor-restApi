//
//  File.swift
//  
//
//  Created by Balogun Kayode on 20/08/2024.
//

import Foundation
import Fluent
import Vapor

struct UserServices: UserProtocol {
    
    typealias Model = UserModel
    
    typealias answer = UserModel.Public
    
    typealias request = Request
    
    typealias createDTO = CreateUserDTO
    
    typealias updateDTO = UpdateUserDTO
    
    typealias status = HTTPStatus

    
    static func create(_ req: Vapor.Request, _createDTO createDTO: CreateUserDTO) async throws -> UserModel.Public {
        let user = UserModel(
            id: UUID(),
            username: createDTO.userName,
            email: createDTO.email,
            password: try Bcrypt.hash(createDTO.password),
            role: RoleEnum.registered.rawValue,
            createdAt: Date(),
            updatedAt: Date(),
            name: createDTO.name
        )
        
        try await user.save(on: req.db)
        return user.convertToPublic()
    }

    static func get(_ req: Vapor.Request, object: String) async throws -> UserModel.Public {
        let uuid = UUID(uuidString: object)
        
        guard let user = try await UserModel.find(uuid, on:req.db) else {
            throw Abort(.notFound, reason: "The user with the ID of \(String(describing: uuid)) could not be found")
        }
        return user.convertToPublic()
    }
    
    
    static func update(_ req: Vapor.Request, object: String, updateDTO: UpdateUserDTO) async throws -> UserModel.Public {
        let uuid = UUID(uuidString: object)
        
        guard let user = try await UserModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "The user with the Id of \(String(describing: uuid)) could not be found")
        }
        user.name = updateDTO.name ?? user.name
        user.lastName = updateDTO.lastName ?? user.lastName
        user.userName = updateDTO.userName ?? user.userName
        user.email = updateDTO.email ?? user.email
        user.city = updateDTO.city ?? user.city
        user.address = updateDTO.address ?? user.address
        user.country = updateDTO.country ?? user.country
        user.postalcode = updateDTO.postalcode ?? user.postalcode
        user.bio = updateDTO.bio ?? user.bio
        
        try await user.save(on: req.db)
        return user.convertToPublic()
//        return .ok
    }
    
    static func delete(_ req: Vapor.Request, object: String) async throws -> Vapor.HTTPStatus {
        let uuid = UUID(uuidString: object)
        
        guard let user = try await UserModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "The user with the Id of \(String(describing: uuid)) could not be found")
        }
        try await user.delete(on: req.db)
        return .ok
    }
    
    
    
}

extension UserServices: SearchUserProtocol {
    func search(_ req: Vapor.Request, term: String) async throws -> [UserModel.Public] {
        let users =  try await UserModel.query(on: req.db)
            .group(.or) {or in
                or.filter(\.$userName =~ term)
                or.filter(\.$name =~ term)
                or.filter(\.$email =~ term)
                or.filter(\.$lastName =~ term)
            }.all()
        
        return users.convertToPublic()
    }
    
    
}
