//
//  File.swift
//  
//
//  Created by Balogun Kayode on 23/08/2024.
//

import Foundation

enum RoutesEnum: String {
    case guides
    case courses
    case articles
    case sessions
    case login
    case register
    case profile
    case delete
    case update
    case users
    case search
    case status
}

enum RouteParameter: String, Equatable {
    case slug = ":slug"
    case id = ":id"
    case status = ":status"
    case term = ":term"
    case article = ":articleSlug"
}
