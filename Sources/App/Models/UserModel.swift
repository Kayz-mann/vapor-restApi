//
//  UserModel.swift
//
//
//  Created by Balogun Kayode on 19/08/2024.
//

import Foundation
import Vapor
import Fluent


final class UserModel: Model {
    
    static let schema: String = SchemaEnum.users.rawValue
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.name)
    var name: String
    
    @OptionalField(key: FieldKeys.lastName)
    var lastName: String?
    
    @OptionalField(key: FieldKeys.userName)
    var userName: String?
    
    @Field(key: FieldKeys.email)
    var email: String
    
    @Field(key: FieldKeys.password)
    var password: String
    
    @Field(key: FieldKeys.verify)
    var verify: Bool?
    
    @OptionalField(key: FieldKeys.city)
    var city: String?
    
    @OptionalField(key: FieldKeys.postalcode)
    var postalcode: String?
    
    @OptionalField(key: FieldKeys.address)
    var address: String?
    
    @OptionalField(key: FieldKeys.country)
    var country: String?
    
    @OptionalField(key: FieldKeys.role)
    var role: RoleEnum.RawValue?
    
    @OptionalField(key: FieldKeys.subscriptionIsActiveTill)
    var subscriptionIsActiveTill: Date?
    
    @OptionalField(key: FieldKeys.myCourses)
    var myCourses: [UUID]?
    
    @OptionalField(key: FieldKeys.completedCourses)
    var completedCourses: [UUID]?

    
    @OptionalField(key: FieldKeys.bio)
    var bio: String?
    
    @OptionalField(key: FieldKeys.userImage)
    var userImage: URL?

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init () {}
    
    //create
    init(id: UUID? ,userName: String?, email: String, password: String, role: RoleEnum.RawValue?, createdAt: Date?, updatedAt: Date?, name: String, verify: Bool?) {
        self.id = id
        self.userName = userName
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.verify = false
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    //update
    init(id: UUID? ,name: String, lastName: String?, userName: String?, email: String, password: String, city: String?, postalcode: String?, country: String?, bio: String?, createdAt: Date?, updateAt: Date?) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.userName = userName
        self.email = email
        self.password = password
        self.city = city
        self.address = address
        self.country = country
        self.bio  = bio
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    
    //this three fields are initialized separately... they cant be edited by user
    init(subscriptionIsActiveTill: Date?) {
        self.subscriptionIsActiveTill = subscriptionIsActiveTill
    }
    
    init(myCourses: [UUID]?) {
        self.myCourses = myCourses
    }
    
    init(completedCourses: [UUID]?) {
        self.completedCourses = completedCourses
    }
    
    init(userImage: URL?) {
        self.userImage = userImage
    }
    
    init(role: RoleEnum.RawValue) {
        self.role  = role
    }
    
    final class Public: Content {
        var id: UUID?
        var userName: String?
        var email: String
        var name: String? =  nil
        var lastName: String?
        var updatedAt: Date?
        var city: String?
        var subscriptionIsActiveTill: Date?
        var myCourses: [UUID]?
        var completedCourses: [UUID]?
        var bio: String?
        
        init(id: UUID? , userName: String?, email: String , name: String, lastName: String? , updatedAt: Date? , city: String? , subscriptionIsActiveTill: Date? , myCourses: [UUID]? , completedCourses: [UUID]? , bio: String? ) {
            self.id = id
            self.userName = userName
            self.email = email
            self.name = name
            self.lastName = lastName
            self.updatedAt = updatedAt
            self.city = city
            self.subscriptionIsActiveTill = subscriptionIsActiveTill
            self.myCourses = myCourses
            self.completedCourses = completedCourses
            self.bio = bio
        }
    }
    

}

extension UserModel: Content {}

extension UserModel {
    func convertToPublic() -> UserModel.Public {
        return UserModel.Public(id: id, userName: userName, email: email, name: name, lastName: lastName, updatedAt: updatedAt, city: city, subscriptionIsActiveTill: subscriptionIsActiveTill, myCourses: myCourses, completedCourses: completedCourses, bio: bio)
    }
}

extension Collection where Element: UserModel {
    func convertToPublic() -> [UserModel.Public] {
        return self.map {
            $0.convertToPublic()
        }
    }
}

extension UserModel: Authenticatable {}

extension UserModel: ModelAuthenticatable {
    static let usernameKey = \UserModel.$email
    static let passwordHashKey = \UserModel.$password
    
    func verify(password:String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension UserModel: ModelSessionAuthenticatable {}
extension UserModel: ModelCredentialsAuthenticatable {}
