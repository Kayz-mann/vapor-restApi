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
    typealias answer = CourseModel
    typealias model = CourseModel
    typealias request = Request
    typealias status = HTTPStatus

    
    func create(_ req: Vapor.Request) async throws -> CourseModel {
        let author = try req.auth.require(UserModel.self) // Requires authenticated user
        let createDTO = try req.content.decode(CreateCourseDTO.self)
        return try await CourseService.create(req, createDTO: createDTO, author: author)
    }
    
    func get(_ req: Vapor.Request) async throws -> CourseModel {
        let slug = req.parameters.get("slug")
        return try await CourseService.get(req, object: slug!)
    }
    
    func getAll(_ req: Vapor.Request) async throws -> [CourseModel] {
        let course =  req.parameters.get("slug")
        return try await CourseService.getAll(req)
    }
    
    func update(_ req: Vapor.Request) async throws -> CourseModel {
        let author = try req.auth.require(UserModel.self) // Requires authenticated user
        let slug = req.parameters.get("slug")
        let updateDTO = try req.content.decode(UpdateCourseDTO.self)
        return try await CourseService.update(req, object: slug!, updateDTO: updateDTO)
    }
    
    func delete(_ req: Vapor.Request) async throws -> HTTPStatus {
        let author = try req.auth.require(UserModel.self) // Requires authenticated user
        let slug = req.parameters.get("slug")
        return try await CourseService.delete(req, object: slug!)
    }
}




extension CourseController: BackendFilterHandlerProtocol {
    func getByStatus(_ req: Request) async throws -> [CourseModel] {
        let status = req.parameters.get("status")
        let courseService = CourseService()  // Create an instance of CourseService
        return try await courseService.getByStatus(req, status: status!)
    }
    
    func search(_ req: Request) async throws -> [CourseModel] {
        let term = req.parameters.get("term")
        let courseService = CourseService()  // Create an instance of CourseService
        return try await courseService.search(req, term: term!)
    }
}

    
    func search(_ req: Vapor.Request, term: String) async throws -> [CourseModel] {
        let courses =  try await CourseModel.query(on: req.db)
            .group(.or) {or in
                or.filter(\.$title =~ term)
            }.all()
        
        return courses
    }
    
    



