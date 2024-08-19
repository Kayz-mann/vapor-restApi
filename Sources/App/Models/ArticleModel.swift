//
//  File.swift
//  
//
//  Created by Balogun Kayode on 19/08/2024.
//

import Foundation
import Vapor
import Fluent

final class ArticleModel: Model {
    static let schema = SchemaEnum.articles.rawValue

    @ID
    var id: UUID?
    
    @OptionalField(key: FieldKeys.title)
    var title: String?
    
    @OptionalField(key: FieldKeys.slug)
    var slug: String?
    
    @OptionalField(key: FieldKeys.excerp)
    var excerp: String?
    
    @OptionalField(key: FieldKeys.content)
    var content: String?
    
    @OptionalField(key: FieldKeys.guide)
    var guide: GuideModel.IDValue?
    
    @OptionalField(key: FieldKeys.headerImage)
    var headerImage: URL?
    
    @OptionalField(key: FieldKeys.author)
    var author: String?
    
    @OptionalField(key: FieldKeys.status)
    var status: StatusEnum.RawValue?
    
    @OptionalField(key: FieldKeys.price)
    var price: PriceEnum.RawValue?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .create)
    var updatedAt: Date?
    
    @OptionalField(key: FieldKeys.publishDate)
    var publishDate: Date?

    
    @OptionalField(key: FieldKeys.tags)
    var tags: [String]?
    
    @OptionalField(key: FieldKeys.role)
    var role: ContentRoleEnum.RawValue?
    
    
    init(){
        
    }
    
    init(title: String?, slug: String?, excerp: String?, content: String?, guide: GuideModel.IDValue?, headerImage: URL?, author: String?, status: StatusEnum.RawValue, price: PriceEnum.RawValue, role: ContentRoleEnum.RawValue?, createdAt: Date?, updatedAt: Date?, publishDate: Date?, tags: [String]?){
        self.title = title
        self.slug = slug
        self.excerp = excerp
        self.content = content
        self.guide = guide
        self.headerImage = headerImage
        self.author = author
        self.status = status
        self.price = price
        self.role = role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishDate = publishDate
        self.tags = tags
    }
    
}
 
extension ArticleModel: Content {}
