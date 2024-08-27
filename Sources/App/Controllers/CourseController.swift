//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation
import Vapor
import Fluent

struct CourseController: ContentHandlerProtocol {
    
    // Associated types defined by ContentHandlerProtocol
    typealias answer = CourseContext
    typealias request = Request
    typealias status = HTTPStatus
    typealias model =  CourseModel
    
    // Conforming to ContentHandlerProtocol methods
    func create(_ req: request) async throws -> CourseModel {
        let author = try req.auth.require(UserModel.self)
        let createDTO = try req.content.decode(CreateCourseDTO.self)
        return try await CourseService.create(req, createDTO: createDTO, author: author)
    }
    
    func get(_ req: request) async throws -> CourseModel {
        guard let slug = req.parameters.get("slug") else {
            throw Abort(.badRequest, reason: "Missing slug parameter")
        }
        return try await CourseService.get(req, object: slug)
    }
    
    func update(_ req: request) async throws -> CourseModel {
        let author = try req.auth.require(UserModel.self)
        guard let slug = req.parameters.get("slug") else {
            throw Abort(.badRequest, reason: "Missing slug parameter")
        }
        let updateDTO = try req.content.decode(UpdateCourseDTO.self)
        return try await CourseService.update(req, object: slug, updateDTO: updateDTO)
    }
    
    func delete(_ req: request) async throws -> status {
        let author = try req.auth.require(UserModel.self)
        guard let slug = req.parameters.get("slug") else {
            throw Abort(.badRequest, reason: "Missing slug parameter")
        }
        return try await CourseService.delete(req, object: slug)
    }
}

extension CourseController: BackendFilterHandlerProtocol {
    func getByStatus(_ req: Request) async throws -> [CourseModel] {
        guard let status = req.parameters.get("status") else {
            throw Abort(.badRequest, reason: "Missing status parameter")
        }
        return try await CourseService().getByStatus(req, status: status)
    }
    
    func search(_ req: Request) async throws -> [CourseModel] {
        guard let term = req.parameters.get("term") else {
            throw Abort(.badRequest, reason: "Missing search term")
        }
        return try await CourseService().search(req, term: term)
    }
}

extension CourseController: FrontendHandlerProtocol {
    
    func getObject(_ req: Vapor.Request) async throws -> CourseContext {
        guard let slug = req.parameters.get("slug") else {
            throw Abort(.badRequest, reason: "Missing slug parameter")
        }
        return try await CourseService.getObject(req, object: slug)
    }
    
    func getAllObjects(_ req: Vapor.Request) async throws -> [CourseModel] {
        return try await CourseService.getAllObjects(req)
    }
}

    



