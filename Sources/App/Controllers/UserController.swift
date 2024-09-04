//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Fluent
import Vapor
import PostgresNIO


struct UserController: UserHandlerProtocol {
    
    typealias answer = UserModel.Public
    typealias request = Request
    typealias status = HTTPStatus
    
    func create(_ req: Vapor.Request) async throws -> UserModel.Public {
        print("Starting user creation process")
        
        do {
            print("Testing database connection")
            try await testDatabaseQuery(req)
            
            print("Decoding CreateUserDTO")
            let createDTO = try req.content.decode(CreateUserDTO.self)
            print("CreateUserDTO decoded successfully: \(createDTO)")
            
            print("Checking if user already exists")
            if try await checkUserExists(req, email: createDTO.email) {
                print("User with email \(createDTO.email) already exists")
                throw Abort(.conflict, reason: "User with this email already exists")
            }
            
            print("Calling UserServices.create")
            let user = try await UserServices.create(req, _createDTO: createDTO)
            print("User created successfully: \(user)")
            
            return user
        } catch let error as DecodingError {
            print("Failed to decode CreateUserDTO: \(String(reflecting: error))")
            throw Abort(.badRequest, reason: "Invalid data format: \(error.localizedDescription)")
        } catch let error as AbortError {
            print("Abort error in create: \(String(reflecting: error))")
            throw error
        } catch let error as PostgresError {
            print("PostgreSQL error in create: \(String(reflecting: error))")
            throw Abort(.internalServerError, reason: "Database error: \(error.localizedDescription)")
        } catch {
            print("Unexpected error in create: \(String(reflecting: error))")
            throw Abort(.internalServerError, reason: "An unexpected error occurred: \(error.localizedDescription)")
        }
    }
    
    func verify(_ req: Vapor.Request) async throws -> HTTPStatus {
        guard let idString = req.parameters.get("id"),
              let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid ID")
        }
        
        guard let user = try await UserModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        if user.role == "admin" {
            user.verify = true
        } else {
            user.verify = true
        }
        
        try await user.update(on: req.db)
        return .ok
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
    
    
    
    private func testDatabaseQuery(_ req: Request) async throws {
        print("Starting database connection test")
        do {
            print("Attempting to query UserModel")
            let count = try await UserModel.query(on: req.db).count()
            print("Database query successful. User count: \(count)")
        } catch let error as PostgresError {
            print("PostgreSQL error in testDatabaseQuery: \(String(reflecting: error))")
            throw Abort(.internalServerError, reason: "Database query failed: \(error.localizedDescription)")
        } catch {
            print("Unexpected error in testDatabaseQuery: \(String(reflecting: error))")
            throw Abort(.internalServerError, reason: "Unexpected error during database test: \(error.localizedDescription)")
        }
        print("Database connection test completed successfully")
    }
    
     private func checkUserExists(_ req: Request, email: String) async throws -> Bool {
         print("Checking if user with email \(email) already exists")
         let user = try await UserModel.query(on: req.db)
             .filter(\.$email == email)
             .first()
         // Correct optional handling
         return user != nil
     }

    
}

//
//extension UserController: SearchUserProtocol {
//    func search(_ req: Request, term: String) async throws -> [UserModel.Public] {
//        let term =  try req.parameters.get("term")
//        
//        let userServices =  UserServices()
//        return try await userServices.search(req, term: term!)
//    }
//}


extension UserController: SearchUserProtocol {
    func search(_ req: Request, term: String) async throws -> [UserModel.Public] {
        let userServices = UserServices()
        return try await userServices.search(req, term: term)
    }
}


final class DatabaseQueryTestResult: Model, Content {
    static let schema = "database_query_test_results"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: Int

    init() { }

    init(id: UUID? = nil, value: Int) {
        self.id = id
        self.value = value
    }
}
