//
//  File.swift
//  
//
//  Created by Balogun Kayode on 20/08/2024.
//

import Foundation
import Vapor
import Fluent

protocol TransformProtocol {
    associatedtype answerWithID
    
    static func getIDFromSlug(_ req: Request, slug: String) async throws -> answerWithID
}
