//
//  File.swift
//  
//
//  Created by Balogun Kayode on 19/08/2024.
//

import Foundation
import Vapor
import Fluent


final class SessionModel: Model {
    static let schema: String = SchemaEnum.sessions.rawValue
    
    @ID
    var id: UUID?
    
    @OptionalField(key: FieldKeys.title)
    var title: String?
    
    @OptionalField(key: FieldKeys.mp4URL)
    var mp4URL: URL?

    
    @OptionalField(key: FieldKeys.hlsURL)
    var hlsURL: URL?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: FieldKeys.publishDate)
    var publishDate: Date?
    
    @OptionalField(key: FieldKeys.status)
    var status: StatusEnum.RawValue?
    
    @OptionalField(key: FieldKeys.price)
    var price: PriceEnum.RawValue?
    
    @OptionalField(key: FieldKeys.article)
    var article: String?
    
    @OptionalField(key: FieldKeys.course)
    var course: CourseModel.IDValue?
    
    @OptionalField(key: FieldKeys.slug)
    var slug: String?
    
    init()  {
        
    }
    
    init(title: String?, mp4URL: URL?, hlsURL: URL?, createdAt: Date?, updatedAt: Date?, publishDate: Date?, price: PriceEnum.RawValue?, article: String?, course: CourseModel.IDValue, slug: String?) {
        self.title = title
        self.mp4URL = mp4URL
        self.hlsURL = hlsURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishDate = publishDate
        self.status = status
        self.price = price
        self.article = article
        self.course = course
        self.slug = slug
        
    }




}

extension SessionModel: Content {}
