//
//  File.swift
//  
//
//  Created by Balogun Kayode on 27/08/2024.
//


import Foundation
import Vapor
import Fluent

struct CheckStudentMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        //check if user is authenticated... check if user has an admin role
        guard let user = request.auth.get(UserModel.self), user.role == RoleEnum.admin.rawValue else {
            throw Abort(.forbidden, reason: "Sorry you need to be subscribed to be able to read this article or watch this content. Please use a subscription plan")
        }
        return try await next.respond(to: request)
    }
}
