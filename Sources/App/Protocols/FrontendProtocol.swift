//
//  File.swift
//  
//
//  Created by Balogun Kayode on 26/08/2024.
//

import Foundation
import Vapor
import Fluent

protocol FrontendProtocol {
    associatedtype model
    associatedtype answer
    associatedtype status
    associatedtype request
    
    
    static func getObject(_ req: request, object: String) async throws -> answer
    static func getAllObjects(_ req: request) async throws -> [model]
    
}

protocol ChangeUserInformationProtocol {
    associatedtype model
    associatedtype status
    associatedtype request
    
    static func addCourseToMyCourses(_ req: request, object: UUID) async throws -> status
    static func addCourseToCompletedCourses(_ req: request, object: UUID) async throws -> status
}

protocol GetSelectedObjectProtocol {
    associatedtype model
    associatedtype request
    
    static func getSelectedObject(_ req: request, object: String) async throws -> model
}

protocol FrontendHandlerProtocol {
    associatedtype model
    associatedtype answer
    associatedtype status
    associatedtype request
    
    func getObject(_ req: request) async throws -> answer
    func getAllObjects(_ req: request) async throws -> [model]
}

protocol GetSelectedObjectHandler {
    associatedtype answer
    associatedtype request
    associatedtype model
    
    func getSelectedObject(_ req: request) async throws -> model
}
