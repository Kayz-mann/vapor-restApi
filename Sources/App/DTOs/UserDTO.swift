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
    let email: String
    let password: String
    let name: String?
    let verify: String
    let userName: String?
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
