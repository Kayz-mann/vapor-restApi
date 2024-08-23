//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Vapor

struct CheckAdminMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        //check if user is authenticated... check if user has an admin role
        guard let user = request.auth.get(UserModel.self), user.role == RoleEnum.admin.rawValue else {
            throw Abort(.forbidden, reason: "Sorry you need admin rights to access this resource, contatc the sys admin if you think this is incorrect")
        }
        return try await next.respond(to: request)
    }
}
