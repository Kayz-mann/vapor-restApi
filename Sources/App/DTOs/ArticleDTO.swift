//
//  File.swift
//  
//
//  Created by Balogun Kayode on 22/08/2024.
//

import Foundation
import Vapor
import Fluent


struct CreateArticleDTO: Content {
    let title: String?
    let excerp: String?
    let content: String?
    let guide: GuideModel.IDValue?
    let headerImage: String?
    let status: StatusEnum.RawValue?
    let price: PriceEnum.RawValue?
    let role: ContentRoleEnum.RawValue?
    let publishDate: Date?
    let tags: [String]
}

struct UpdateArticleDTO: Content {
    let title: String?
    let excerp: String?
    let content: String?
    let guide: GuideModel.IDValue?
    let headerImage: String?
    let status: StatusEnum.RawValue?
    let price: PriceEnum.RawValue?
    let role: ContentRoleEnum.RawValue?
    let publishDate: Date?
    let tags: [String]

}
