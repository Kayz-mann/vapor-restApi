//
//  File.swift
//  
//
//  Created by Balogun Kayode on 27/08/2024.
//

import Foundation
import Vapor

struct GuideContext: Content {
    let guide: GuideModel
    let articles: [ArticleModel]?
}
