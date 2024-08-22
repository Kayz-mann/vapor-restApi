//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Vapor
import Fluent

struct AuthController: AuthProtocol {
    func loginHandler(_ req: Request) throws -> EventLoopFuture<TokenModel> {
        let user = try req.auth.require(UserModel.self)
        let token = try TokenModel.generate(for: user)
        return token.save(on: req.db).map {
            token
        }
    }
}



//fieldkey-model-dto-protocol-service-migration-controller
