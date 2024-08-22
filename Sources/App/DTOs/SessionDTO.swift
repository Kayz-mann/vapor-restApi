//
//  File.swift
//  
//
//  Created by Balogun Kayode on 21/08/2024.
//

import Foundation
import Fluent
import Vapor



struct CreateSessionDTO: Content {
    let title: String?
    let mp4URL: URL?
    let hlsURL: URL?
    let publishDate: Date?
    let status: StatusEnum.RawValue?
    let price: PriceEnum.RawValue
    let article: String?
    let course: CourseModel.IDValue
    
}


struct UpdateSessionDTO: Content {
    let title: String?
    let mp4URL: URL?
    let hlsURL: URL?
    let publishDate: Date?
    let status: StatusEnum.RawValue?
    let price: PriceEnum.RawValue
    let article: String?
    let course: CourseModel.IDValue
    
}

