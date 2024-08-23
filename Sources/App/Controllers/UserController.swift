//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Fluent
import Vapor


struct UserController: UserHandlerProtocol {
    
    typealias answer = UserModel.Public
    typealias request = Request
    typealias status = HTTPStatus
    
    func create(_ req: Vapor.Request) async throws -> UserModel.Public {
        let user =  try req.content.decode(CreateUserDTO.self)
        return try await UserServices.create(req, _createDTO: user)
    }
    
    func get(_ req: Vapor.Request) async throws -> UserModel.Public {
        let user =  try req.auth.require(UserModel.self)
        return try await UserServices.get(req, object: user.id!.uuidString)
    }
    
    func update(_ req: Vapor.Request) async throws -> UserModel.Public {
        let user =  try await req.auth.require(UserModel.self)
        let updatedUser = try req.content.decode(UpdateUserDTO.self)
        return try await UserServices.update(req, object: user.id!.uuidString, updateDTO: updatedUser)
    }
    
    func delete(_ req: Vapor.Request) async throws -> Vapor.HTTPStatus {
        let user =  try req.auth.require(UserModel.self)
        return try await UserServices.delete(req, object: user.id!.uuidString)
    }

}
