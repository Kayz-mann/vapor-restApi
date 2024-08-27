//
//  File.swift
//  
//
//  Created by Balogun Kayode on 20/08/2024.
//

import Foundation
import Vapor
import Fluent

struct CourseService: ContentProtocol {
    
    typealias answer = CourseContext
    typealias model = CourseModel
    typealias request = Request
    typealias status = HTTPStatus
    typealias createDTO = CreateCourseDTO
    typealias updateDTO = UpdateCourseDTO
    
    static func create(_ req: Vapor.Request, createDTO: CreateCourseDTO, author: UserModel) async throws -> CourseModel {
        let slug = createDTO.title?.replacingOccurrences(of: " ", with: "-").lowercased() // Replaced empty string with space
        
        let course = CourseModel(
            title: createDTO.title,
            slug: slug,
            tags: createDTO.tags,
            description: createDTO.description,
            status: createDTO.status ?? StatusEnum.draft.rawValue, // Fixed the status field to use `createDTO.status`
            price: createDTO.price ?? PriceEnum.pro.rawValue,
            headerImage: URL(string: createDTO.headerImage!),
            article: createDTO.article,
            topHexColor: createDTO.topHexColor,
            bottomHexColor: createDTO.bottomHexColor,
            syllabus: URL(string: createDTO.syllabus!),
            assets: URL(string: createDTO.assets!),
            author: author.id?.uuidString ?? "", // Set the author as the ID of the author user
            createdAt: Date(),
            updatedAt: Date(),
            publishDate: createDTO.publishDate)
        
        try await course.save(on: req.db)
        return course
    }
    
    static func get(_ req: Vapor.Request, object: String) async throws -> CourseModel {
        guard let course = try await CourseModel.query(on: req.db).filter(\.$slug == object).first() else {
            throw Abort(.notFound, reason: "Could not find course with slug \(object)")
        }
        return course
    }
    
    static func getAll(_ req: Vapor.Request) async throws -> [CourseModel] {
        return try await CourseModel.query(on: req.db)
            // Uncomment and use proper filtering if needed
            // .filter(\.$status == StatusEnum.draft.rawValue || \.$status == StatusEnum.published.rawValue || \.$status == StatusEnum.planned.rawValue)
            .all()
    }
    
    static func update(_ req: Vapor.Request, object: String, updateDTO: UpdateCourseDTO) async throws -> CourseModel {
        let uuid = try await getIDFromSlug(req, slug: object)
        
        guard let course = try await CourseModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "Course with ID \(uuid) could not be found")
        }
        
        course.title = updateDTO.title ?? course.title
        course.tags = updateDTO.tags ?? course.tags
        course.description = updateDTO.description ?? course.description
        course.status = updateDTO.status ?? course.status
        course.price = updateDTO.price ?? course.price
        course.headerImage = URL(string: updateDTO.headerImage!) ?? course.headerImage
        course.article = updateDTO.article ?? course.article
        course.topHexColor = updateDTO.topHexColor ?? course.topHexColor
        course.bottomHexColor = updateDTO.bottomHexColor ?? course.bottomHexColor
        course.syllabus = URL(string: updateDTO.syllabus!)  ?? course.syllabus
        course.assets = URL(string: updateDTO.assets!) ?? course.assets
        course.publishDate = updateDTO.publishDate ?? course.publishDate
        
        try await course.save(on: req.db)
        return course
    }
    
    static func delete(_ req: Vapor.Request, object: String) async throws -> Vapor.HTTPStatus {
        let uuid = try await getIDFromSlug(req, slug: object)
        
        guard let course = try await CourseModel.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "Course with ID \(uuid) could not be found")
        }
        try await course.delete(on: req.db)
        return .ok
    }
}

extension CourseService: TransformProtocol {
    static func getIDFromSlug(_ req: Vapor.Request, slug: String) async throws -> UUID {
        guard let course = try await CourseModel.query(on: req.db)
            .filter(\.$slug == slug)
            .first() else {
                throw Abort(.notFound, reason: "Course ID could not be found")
            }
        return course.id! // Unwrap the ID safely, or handle if `id` is optional
    }
    
    typealias answerWithID = UUID
}


extension CourseService: BackendContentFilterProtocol {
    func getByStatus(_ req: Vapor.Request, status: StatusEnum.RawValue) async throws -> [CourseModel] {
        let courses =  try await CourseModel.query(on: req.db)
            .filter(\.$status == status)
            .all()
        return courses
    }
    
    
    func search(_ req: Vapor.Request, term: String) async throws -> [CourseModel] {
        let courses =  try await CourseModel.query(on: req.db)
            .group(.or) {or in
                or.filter(\.$title =~ term)
            }.all()
        
        return courses
    }
    
    
}

extension CourseService: FrontendProtocol {
    static func getObject(_ req: Vapor.Request, object: String) async throws -> CourseContext {
        let user =  try req.auth.get(UserModel.self)
        
        
        guard let course = try await CourseModel.query(on: req.db)
            .filter(\.$slug == object)
            .filter(\.$status == StatusEnum.published.rawValue)
            .first() else {
                throw Abort(.notFound)
            }

        
        let sessions =  try await SessionModel.query(on: req.db)
            .filter(\.$course == course.id)
            .filter(\.$status == StatusEnum.published.rawValue)
            .all()
        
        //if user is a student the user gets courses with sessions else nil
        return user?.role ==  RoleEnum.student.rawValue ? CourseContext(course: course, sessions: sessions): CourseContext(course: course, sessions: nil)
        
    }
    
        //return all published courses
    static func getAllObjects(_ req: Vapor.Request) async throws -> [CourseModel] {
        let courses =  try await CourseModel.query(on: req.db)
            .filter(\.$status == StatusEnum.published.rawValue)
            .all()
        return courses
    }
    
    
}


