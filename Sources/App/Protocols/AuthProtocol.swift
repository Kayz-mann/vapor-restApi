//
//  File.swift
//  
//
//  Created by Balogun Kayode on 20/08/2024.
//

import Foundation
import Fluent
import Vapor

protocol AuthProtocol {
    func loginHandler(_ req: Request) throws ->  EventLoopFuture<TokenModel>
}
