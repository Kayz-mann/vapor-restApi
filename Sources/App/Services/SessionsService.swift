//
//  File.swift
//  
//
//  Created by Balogun Kayode on 21/08/2024.
//

import Foundation
import Fluent
import Vapor

struct SessionsService: ContentProtocol {
    
    typealias answer = SessionModel
    
    typealias model = SessionModel
    
    typealias request = Request
    
    typealias status = HTTPStatus
    
    typealias createDTO = CreateSessionDTO
    
    typealias updateDTO = UpdateSessionDTO
    
    
    
    static func create(_ req: Vapor.Request, createDTO: CreateSessionDTO, author: UserModel) async throws -> Vapor.HTTPStatus {
        guard let course = try await CourseModel.find(createDTO.course, on: req.db) else {
            throw Abort(.notFound, reason: "Course with ID of \(createDTO.course) could not be found")
        }
        
        let slug =  createDTO.title?.replacingOccurrences(of: "", with: "_")
        let session = SessionModel(
            title: createDTO.title,
            mp4URL: createDTO.mp4URL,
            hlsURL: createDTO.hlsURL,
            createdAt: Date(),
            updatedAt: Date(),
            publishDate: createDTO.publishDate,
            price: createDTO.price ?? course.price,
            article: createDTO.article,
            course: createDTO.course,
            slug: slug)
        
        try await session.save(on: req.db)
        return .ok
    }
    
    static func get(_ req: Vapor.Request, object: String) async throws -> SessionModel {
        guard let session = try await SessionModel.query(on: req.db)
            .filter(\.$slug == object)
            .first() else {
            throw Abort(.notFound, reason: "Session was not found")
        }
        return session
    }
    
    static func getAll(_ req: Vapor.Request) async throws -> [SessionModel] {
        return try await SessionModel.query(on: req.db).all()
    }
    
    static func update(_ req: Vapor.Request, object: String, updateDTO: UpdateSessionDTO) async throws -> SessionModel {
        let uuid =  try await getIDFromSlug(req, slug: object)
        
       guard let session = try await SessionModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "Session with ID of \(uuid) could not be found")
        }
        
        session.title = updateDTO.title ?? session.title
        session.mp4URL = updateDTO.mp4URL ?? session.mp4URL
        session.hlsURL = updateDTO.hlsURL ?? session.hlsURL
        session.publishDate = updateDTO.publishDate ?? session.publishDate
        session.price = updateDTO.price ?? session.price
        session.article = updateDTO.article ?? session.article
        session.course = updateDTO.course ?? session.course
        session.updatedAt = Date()
        
        try await session.save(on: req.db)
        return session
    }
    
    static func delete(_ req: Vapor.Request, object: String) async throws -> Vapor.HTTPStatus {
        let uuid = try await getIDFromSlug(req, slug: object)
        
        guard let session = try await SessionModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "Session with ID of \(uuid) could not be found")
        }
        try await session.delete(on: req.db)
        return .ok
        
    }
        
    
}


extension SessionsService: TransformProtocol {
    static func getIDFromSlug(_ req: Vapor.Request, slug: String) async throws -> UUID {
        guard let session = try await SessionModel.query(on: req.db)
            .filter(\.$slug == slug)
            .first() else {
                throw Abort(.notFound, reason: "Session was not found")
            }
        return session.id!
    }
    
    typealias answerWithID = UUID
}

