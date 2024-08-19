//
//  File.swift
//  
//
//  Created by Balogun Kayode on 19/08/2024.
//

import Foundation
import Fluent

extension GuideModel {
    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var description: FieldKey { "description" }
        static var headerImage: FieldKey { "headerImage" }
        static var price: FieldKey { "price" }
        static var status: FieldKey { "status" }
        static var slug: FieldKey { "slug" }
        static var tags: FieldKey { "tags" }
        static var publishDate: FieldKey { "publishDate" }
        static var createdAt: FieldKey { "createdAt" }
        static var updatedAt: FieldKey { "updatedAt" }
        static var author: FieldKey { "author" }
    }
}
