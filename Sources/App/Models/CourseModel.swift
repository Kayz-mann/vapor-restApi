//
//  File.swift
//  
//
//  Created by Balogun Kayode on 19/08/2024.
//

import Foundation
import Vapor
import Fluent

final class CourseModel: Model {
    static let schema: String = SchemaEnum.courses.rawValue
    
    @ID
    var id: UUID?
    
    @OptionalField(key: FieldKeys.title)
    var title: String?
    
    @OptionalField(key: FieldKeys.slug)
    var slug: String?
    
    @OptionalField(key: FieldKeys.tags)
    var tags: [String]?
    
    @OptionalField(key: FieldKeys.description)
    var description: String?
    
    @OptionalField(key: FieldKeys.status)
    var status: StatusEnum.RawValue?
    
    @OptionalField(key: FieldKeys.price)
    var price: StatusEnum.RawValue?
    
    @OptionalField(key: FieldKeys.headerImage)
    var headerImage: URL?
    
    @OptionalField(key: FieldKeys.article)
    var article: String?
    
    @OptionalField(key: FieldKeys.topHexColor)
    var topHexColor: String?
    
    @OptionalField(key: FieldKeys.bottomHexColor)
    var bottomHexColor: String?
    
    @OptionalField(key: FieldKeys.syllabus)
    var syllabus: String?
    
    @OptionalField(key: FieldKeys.assets)
    var assets: URL?
    
    @OptionalField(key: FieldKeys.author)
    var author: String?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: FieldKeys.publishDate)
    var publishDate: Date?
    
    
    init() {
        
    }
    
    init(title: String?, slug: String?, tags: [String]?, description: String?, status: StatusEnum.RawValue, price: PriceEnum.RawValue, headerImage: URL?, article: String?, topHexColor: String?, bottomHexColor: String?, syllabus: String?, assets: URL?, author: String?, createdAt: Date?, updatedAt: Date?, publishDate: Date?) {
        self.title = title
        self.slug = slug
        self.tags = tags
        self.description = description
        self.status = status
        self.price = price
        self.headerImage = headerImage
        self.article  = article
        self.topHexColor = topHexColor
        self.bottomHexColor = bottomHexColor
        self.syllabus = syllabus
        self.assets = assets
        self.author = author
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishDate = publishDate
    }
    
    init(status: StatusEnum.RawValue) {
        self.status = status
    }






}
