//
//  File.swift
//  
//
//  Created by Balogun Kayode on 19/08/2024.
//

import Foundation
import Vapor
import Fluent

final class GuideModel: Model {
    static let schema: String = SchemaEnum.guides.rawValue
    
    @ID
    var id: UUID?
    
    @OptionalField(key: FieldKeys.title)
    var title: String?
    
    @OptionalField(key: FieldKeys.description)
    var description: String?
    
    @OptionalField(key: FieldKeys.headerImage)
    var headerImage: URL?
    
    @OptionalField(key: FieldKeys.price)
    var price: PriceEnum.RawValue?
    
    @OptionalField(key: FieldKeys.status)
    var status: StatusEnum.RawValue?
    
    @OptionalField(key: FieldKeys.slug)
    var slug: String?
    
    @OptionalField(key: FieldKeys.tags)
    var tags: [String]?
    
    @OptionalField(key: FieldKeys.publishDate)
    var publishDate: Date?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: FieldKeys.author)
    var author: String?
    
    init()  {}
    
    init(title: String?, description: String?, headerImage: URL?, price: PriceEnum.RawValue?, status: StatusEnum.RawValue?, slug: String?, tags: [String]?, publishDate: Date?, createdAt: Date?, updatedAt: Date?) {
        self.title = title
        self.description = description
        self.headerImage = headerImage
        self.price = price
        self.status  = status
        self.slug = slug
        self.tags = tags
        self.publishDate = publishDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.author = author
    }
    
    init(status: StatusEnum.RawValue?)  {
        self.status = status
    }
}

extension GuideModel: Content {}
