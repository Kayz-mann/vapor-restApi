//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Vapor
import Fluent

struct GuideController: ContentHandlerProtocol {
    

    typealias answer = GuideContext
    typealias model = GuideModel
    typealias request = Request
    typealias status = HTTPStatus
    
    func create(_ req: Vapor.Request) async throws -> GuideModel {
        guard let author = try? req.auth.get(UserModel.self) else {
            throw Abort(.unauthorized) // Or another appropriate error
        }
        
        let guide = try req.content.decode(CreateGuideDTO.self)
        return try await GuideService.create(req, createDTO: guide, author: author)
    }

    
    func get(_ req: Vapor.Request) async throws -> GuideModel {
        let guide =  req.parameters.get("slug")
        return try await GuideService.get(req, object: guide!)
    }
    
    func getAll(_ req: Vapor.Request) async throws -> [GuideModel] {
        return try await GuideService.getAll(req)
    }
    
    func update(_ req: Vapor.Request) async throws -> GuideModel {
        let guide =  req.parameters.get("slug")
        let updatedGuide =  try req.content.decode(UpdateGuideDTO.self)
        return try await GuideService.update(req, object: guide!, updateDTO: updatedGuide)
    }
    
    func delete(_ req: Vapor.Request) async throws -> Vapor.HTTPStatus {
        let guide =  req.parameters.get("slug")
        return try await GuideService.delete(req, object: guide!)
    }

}


extension GuideController: BackendFilterHandlerProtocol{
     func getByStatus(_ req: Vapor.Request) async throws -> [GuideModel] {
        let status =  req.parameters.get("slug")
         let guideService  = GuideService()
        return try await guideService.getByStatus(req, status: status!)
    }
    
    func search(_ req: Vapor.Request) async throws -> [GuideModel] {
        let term =  req.parameters.get("term")
        let guideService  = GuideService()
        return try await guideService.search(req, term: term!)
    }
    
}

extension GuideController: FrontendHandlerProtocol {
    func getObject(_ req: Vapor.Request) async throws -> GuideContext{
        let guide = req.parameters.get("slug")
        return try await GuideService.getObject(req, object: guide!)
    }
    
    func getAllObjects(_ req: Vapor.Request) async throws -> [GuideModel] {
        return try await GuideService.getAllObjects(req)
    }
}







