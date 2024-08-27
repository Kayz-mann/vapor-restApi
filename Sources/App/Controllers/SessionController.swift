//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Fluent
import Vapor

struct SessionController: ContentHandlerProtocol {
    
    typealias answer = SessionModel
    typealias model  = SessionModel
    typealias request = Request
    typealias status = HTTPStatus
    
    
    func create(_ req: Vapor.Request) async throws -> SessionModel {
        let author =  req.auth.get(UserModel.self)
        let session =  try await req.content.decode(CreateSessionDTO.self)
        return try await SessionsService.create(req, createDTO: session, author: author!)
    }
    
    func get(_ req: Vapor.Request) async throws -> SessionModel {
        let session =  req.parameters.get("slug")
        return try await SessionsService.get(req, object: session!)
    }
    
    func getAll(_ req: Vapor.Request) async throws -> [SessionModel] {
        let session =  req.parameters.get("slug")
        return try await SessionsService.getAll(req)
    }

    
    func update(_ req: Vapor.Request) async throws -> SessionModel {
        let session =  req.parameters.get("slug")
        let updatedSession =  try req.content.decode(UpdateSessionDTO.self)
        return try await SessionsService.update(req, object: session!, updateDTO: updatedSession)
    }
    
    func delete(_ req: Vapor.Request) async throws -> Vapor.HTTPStatus {
        let session =  req.parameters.get("slug")
        return try await SessionsService.delete(req, object: session!)
    }
    
    
}


extension SessionController: BackendFilterHandlerProtocol{
     func getByStatus(_ req: Vapor.Request) async throws -> [SessionModel] {
        let status =  req.parameters.get("slug")
         let sessionService  = SessionsService()
        return try await sessionService.getByStatus(req, status: status!)
    }
    
    func search(_ req: Vapor.Request) async throws -> [SessionModel] {
        let term =  req.parameters.get("term")
        let sessionService  = SessionsService()
        return try await sessionService.search(req, term: term!)
    }
    
}

extension SessionController: GetSelectedObjectHandler {
    func getSelectedObject(_ req: Vapor.Request) async throws -> SessionModel {
        let article =  req.parameters.get("sessionSlug")
        return try await SessionsService.getSelectedObject(req, object: article!)
    }
}


