//
//  File.swift
//  
//
//  Created by Balogun Kayode on 22/08/2024.
//

import Foundation
import Fluent
import Vapor

struct GuideService: ContentProtocol {

    
    typealias answer = GuideContext
    
    typealias model = GuideModel
    
    typealias request = Request
    
    typealias status = HTTPStatus
    
    typealias createDTO = CreateGuideDTO
    
    typealias updateDTO = UpdateGuideDTO
    
    
    static func create(_ req: Vapor.Request, createDTO: CreateGuideDTO, author: UserModel) async throws -> GuideModel {
        let fullAuthor = "\(author.name) \(author.lastName)"
        let slug = createDTO.title?.replacingOccurrences(of: "", with: "_")
        
        let guide = GuideModel(
            title: createDTO.title,
            description: createDTO.description,
            headerImage: URL(string: createDTO.headerImage!),
            price: createDTO.price,
            status: createDTO.status ?? StatusEnum.draft.rawValue,
            author: fullAuthor,
            slug: slug,
            tags: createDTO.tags,
            publishDate: createDTO.publishDate,
            createdAt: Date(),
            updatedAt: Date())
        
       var res =  try await guide.save(on: req.db)
        return guide
    }
    
    static func get(_ req: Vapor.Request, object: String) async throws -> GuideModel {
        guard let guide = try await GuideModel.query(on: req.db)
            .filter(\.$slug == object)
            .first() else {
                throw Abort(.notFound, reason: "Guide could not be found")
            }
        return guide
    }
    
    static func getAll(_ req: Vapor.Request) async throws -> [GuideModel] {
        return try await GuideModel.query(on: req.db).all()
    }
    
    static func update(_ req: Vapor.Request, object: String, updateDTO: UpdateGuideDTO) async throws -> GuideModel {
        let uuid = try await getIDFromSlug(req, slug: object)
        guard let guide =  try await GuideModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "Guide with ID of \(uuid) could not be found")
        }
        
        guide.title = updateDTO.title ?? guide.title
        guide.description = updateDTO.description ?? guide.description
        guide.headerImage =  URL(string: updateDTO.headerImage!) ??  guide.headerImage
        guide.price = updateDTO.price ?? guide.price
        guide.status = updateDTO.status ?? guide.status
        guide.tags = updateDTO.tags ?? guide.tags
        guide.publishDate = updateDTO.publishDate ?? guide.publishDate
        
        try await guide.save(on: req.db)
        return guide
    }
    
    static func delete(_ req: Vapor.Request, object: String) async throws -> Vapor.HTTPStatus {
        let uuid = try await getIDFromSlug(req, slug: object)
        
        guard let guide = try await GuideModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "Guide with ID of \(uuid) could not be found")
        }
        try await guide.delete(on: req.db)
        return .ok
    }
    
    
}


extension GuideService: TransformProtocol {
    static func getIDFromSlug(_ req: Vapor.Request, slug: String) async throws -> UUID {
        guard let guide = try await GuideModel.query(on: req.db)
            .filter(\.$slug == slug)
            .first() else {
                throw Abort(.notFound, reason: "Guide ID could not be found")
            }
        return guide.id!
    }
    typealias answerWithID = UUID
}



extension GuideService: BackendContentFilterProtocol {
    func getByStatus(_ req: Vapor.Request, status: StatusEnum.RawValue) async throws -> [GuideModel] {
       let guides =  try await GuideModel.query(on: req.db)
           .filter(\.$status == status)
           .all()
       return guides
   }

    func search(_ req: Vapor.Request, term: String) async throws -> [GuideModel] {
       let guides =  try await GuideModel.query(on: req.db)
           .group(.or) {or in
               or.filter(\.$title =~ term)
           }.all()
       
       return guides
   }

}

extension GuideService: FrontendProtocol {
    static func getObject(_ req: Vapor.Request, object: String) async throws -> GuideContext {
        let user =  req.auth.get(UserModel.self)
        
        guard let guide =  try await GuideModel.query(on: req.db)
            .filter(\.$slug ==  object)
            .filter(\.$status == StatusEnum.published.rawValue)
            .first() else {
            throw Abort(.notFound)
        }
        
        let articles =  try await ArticleModel.query(on: req.db)
            .filter(\.$guide == guide.id)
            .filter(\.$status ==  StatusEnum.published.rawValue)
            .all()
        
        return user?.role == RoleEnum.student.rawValue ? GuideContext(guide: guide, articles: articles) : GuideContext(guide: guide, articles: nil)
    }
    
    static func getAllObjects(_ req: Vapor.Request) async throws -> [GuideModel] {
        let guide =  try await GuideModel.query(on: req.db)
            .filter(\.$status ==  StatusEnum.published.rawValue)
            .all()
        return guide
    }
    
    
}
