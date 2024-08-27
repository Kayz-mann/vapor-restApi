//
//  File.swift
//  
//
//  Created by Balogun Kayode on 20/08/2024.
//

import Foundation
import Vapor
import Fluent

struct CreateCourseDTO: Content {
    let title: String?
    let tags: [String]?
    let description: String?
    let status: StatusEnum.RawValue
    let price: PriceEnum.RawValue
    let headerImage: String?
    let topHexColor: String?
    let bottomHexColor: String?
    let syllabus: String?
    let assets: String?
    let article: String?
    let publishDate: Date?
}

struct UpdateCourseDTO: Content {
    let title: String?
    let tags: [String]?
    let description: String?
    let status: StatusEnum.RawValue
    let price: PriceEnum.RawValue
    let headerImage: String?
    let topHexColor: String?
    let bottomHexColor: String?
    let syllabus: String?
    let assets: String?
    let article: String?
    let publishDate: Date?
}
