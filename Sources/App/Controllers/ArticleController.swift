//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Fluent
import Vapor


struct ArticleController: ContentHandlerProtocol {
    
    typealias answer = ArticleModel
    typealias model = ArticleModel
    typealias request = Request
    typealias status = HTTPStatus
    
    
    func create(_ req: Vapor.Request) async throws -> ArticleModel {
        let author =  req.auth.get(UserModel.self)
        let article =  try req.content.decode(CreateArticleDTO.self)
        return try await ArticleService.create(req, createDTO: article, author: author!)
    }
    
    func get(_ req: Vapor.Request) async throws -> ArticleModel {
        let article =  req.parameters.get("slug")
        return try await ArticleService.get(req, object: article!)
    }
    
    func getAll(_ req: Vapor.Request) async throws -> [ArticleModel] {
        let article =  req.parameters.get("slug")
        return try await ArticleService.getAll(req)
    }
    
    func update(_ req: Vapor.Request) async throws -> ArticleModel {
        let article =  req.parameters.get("slug")
        let updatedArticle =  try req.content.decode(UpdateArticleDTO.self)
        return try await ArticleService.update(req, object: article!, updateDTO: updatedArticle)

    }
    
    func delete(_ req: Vapor.Request) async throws -> Vapor.HTTPStatus {
        let article  =  req.parameters.get("slug")
        return try await ArticleService.delete(req, object: article!)
    }

}

extension ArticleController: BackendFilterHandlerProtocol {
    func getByStatus(_ req: Vapor.Request) async throws -> [ArticleModel] {
        let status = req.parameters.get("slug")
        let service = ArticleService()
        return try await service.getByStatus(req, status: status!)
    }
    
    func search(_ req: Vapor.Request) async throws -> [ArticleModel] {
        let term = req.parameters.get("term")
        let service = ArticleService()
        return try await service.search(req, term: term!)
    }
}


extension ArticleController: GetSelectedObjectHandler {
    func getSelectedObject(_ req: Vapor.Request) async throws -> ArticleModel {
        let article =  req.parameters.get("articleSlug")
        return try await ArticleService.getSelectedObject(req, object: article!)
    }
}
