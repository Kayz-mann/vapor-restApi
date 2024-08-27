//
//  File.swift
//  
//
//  Created by Balogun Kayode on 22/08/2024.
//

import Foundation
import Vapor
import Fluent

struct CreateGuideDTO: Content {
    let title: String?
    let description: String?
    let headerImage: String?
    let price: PriceEnum.RawValue?
    let status: StatusEnum.RawValue?
    let tags: [String]?
    let publishDate: Date?
}

struct UpdateGuideDTO: Content {
    let title: String?
    let description: String?
    let headerImage: String?
    let price: PriceEnum.RawValue?
    let status: StatusEnum.RawValue?
    let tags: [String]?
    let publishDate: Date?

}
