//
//  File.swift
//  
//
//  Created by Balogun Kayode on 27/08/2024.
//

import Foundation
import Vapor
import Fluent


struct CourseContext: Content {
    let course: CourseModel
    let sessions: [SessionModel]?
}
