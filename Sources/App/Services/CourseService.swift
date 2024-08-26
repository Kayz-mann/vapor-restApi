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
    
    typealias answer = CourseModel
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
            headerImage: createDTO.headerImage,
            article: createDTO.article,
            topHexColor: createDTO.topHexColor,
            bottomHexColor: createDTO.bottomHexColor,
            syllabus: createDTO.syllabus,
            assets: createDTO.assets,
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
        course.headerImage = updateDTO.headerImage ?? course.headerImage
        course.article = updateDTO.article ?? course.article
        course.topHexColor = updateDTO.topHexColor ?? course.topHexColor
        course.bottomHexColor = updateDTO.bottomHexColor ?? course.bottomHexColor
        course.syllabus = updateDTO.syllabus ?? course.syllabus
        course.assets = updateDTO.assets ?? course.assets
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


