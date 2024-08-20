//
//  File.swift
//  
//
//  Created by Balogun Kayode on 20/08/2024.
//

import Foundation
import Vapor
import Fluent

protocol ContentFilterProtocol {
    associatedtype request
    associatedtype answer
    associatedtype model
    associatedtype status
    
    func search(_ req: request, term: String) async throws -> [model]
}

protocol BackendContentFilterProtocol {
    associatedtype request
    associatedtype answer
    associatedtype model
    associatedtype status
    
    
    func getByStatus(_ req: request, status: StatusEnum.RawValue) async throws -> [model]
    func getAllWithStatus(_ req: request) async throws -> [model]
    func search(_ req: request, term: String) async throws -> [model]
    
}
