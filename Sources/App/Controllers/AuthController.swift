//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Vapor
import Fluent

struct LoginDTO: Content {
    let userName: String
    let password: String
}

struct AuthController: AuthProtocol {
    func loginHandler(_ req: Request) throws -> EventLoopFuture<TokenModel> {
        let loginDTO = try req.content.decode(LoginDTO.self)

        // find the user by email
        return UserModel.query(on: req.db)
        .filter(\.$userName == loginDTO.userName)
        .first()
        .unwrap(or: Abort(.unauthorized, reason: "Invalid credentials"))
        .flatMapThrowing { user in 
        // Verify password
        let isPasswordValid = try user.verify(password: loginDTO.password)
        guard isPasswordValid else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
            // check if user is verified 
            // guard user.verify == true else {
            //     throw Abort(.unauthorized, reason: "Account not verified")
            // }
            return user

        }.flatMap { user in 
        // Generate tojen for the authenticated user
            let token = try! TokenModel.generate(for: user)
            return token.save(on: req.db).map {
                token
            }
        }
        // let user = try req.auth.require(UserModel.self)
        // let token = try TokenModel.generate(for: user)
        // return token.save(on: req.db).map {
        //     token
        // }
    }
}



//fieldkey-model-dto-protocol-service-migration-controller
