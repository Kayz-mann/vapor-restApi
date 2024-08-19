//
//  File.swift
//  
//
//  Created by Balogun Kayode on 19/08/2024.
//

import Foundation
import Fluent
import Vapor

extension ArticleModel {
    struct FieldKeys {
        static var title: FieldKey {"title"}
        static var slug: FieldKey {"slug"}
        static var excerp: FieldKey {"excerp"}
        static var content: FieldKey {"content"}
        static var guide: FieldKey {"guide"}
        static var headerImage: FieldKey {"headerImage"}
        static var author: FieldKey {"author"}
        static var status: FieldKey {"status"}
        static var price: FieldKey {"price"}
        static var role: FieldKey {"role"}
        static var createdAt: FieldKey {"createdAt"}
        static var updatedAt: FieldKey {"updatedAt"}
        static var publishDate: FieldKey {"publishDate"}
        static var tags: FieldKey {"tags"}
    }
}
