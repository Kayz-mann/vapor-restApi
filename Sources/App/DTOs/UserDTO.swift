//
//  File.swift
//  
//
//  Created by Balogun Kayode on 20/08/2024.
//

import Foundation
import Fluent
import Vapor

struct CreateUserDTO: Content {
    let userName: String
    let email: String
    let password: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case userName
        case email
        case password
        case name
    }
}

struct UpdateUserDTO: Content {
    let name: String
    let lastName: String
    let userName: String
    let email: String?
    let city: String?
    let address: String?
    let country: String?
    let postalcode: String?
    let bio: String?
    
}
