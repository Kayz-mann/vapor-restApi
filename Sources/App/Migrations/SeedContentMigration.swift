//
//  SeedContentMigration.swift
//
//
//  Created by Claude Code
//

import Foundation
import Fluent
import Vapor

struct SeedContentMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        // Create Courses
        let swiftCourse = CourseModel(
            title: "Swift Programming Masterclass",
            slug: "swift-programming-masterclass",
            tags: ["swift", "ios", "programming", "beginner"],
            description: "Learn Swift programming from scratch. Perfect for beginners who want to start iOS development.",
            status: StatusEnum.published.rawValue,
            price: PriceEnum.free.rawValue,
            headerImage: URL(string: "https://example.com/images/swift-course.jpg"),
            article: "This comprehensive course covers all the fundamentals of Swift programming language.",
            topHexColor: "#FF6B6B",
            bottomHexColor: "#4ECDC4",
            syllabus: URL(string: "https://example.com/syllabus/swift.pdf"),
            assets: URL(string: "https://example.com/assets/swift.zip"),
            author: "John Doe",
            createdAt: Date(),
            updatedAt: Date(),
            publishDate: Date()
        )

        let vaporCourse = CourseModel(
            title: "Server-Side Swift with Vapor",
            slug: "server-side-swift-vapor",
            tags: ["swift", "vapor", "backend", "api", "advanced"],
            description: "Build powerful REST APIs and web applications using Vapor framework.",
            status: StatusEnum.published.rawValue,
            price: PriceEnum.pro.rawValue,
            headerImage: URL(string: "https://example.com/images/vapor-course.jpg"),
            article: "Master server-side Swift development with this advanced Vapor course.",
            topHexColor: "#5B86E5",
            bottomHexColor: "#36D1DC",
            syllabus: URL(string: "https://example.com/syllabus/vapor.pdf"),
            assets: URL(string: "https://example.com/assets/vapor.zip"),
            author: "Jane Smith",
            createdAt: Date(),
            updatedAt: Date(),
            publishDate: Date()
        )

        let swiftUICourse = CourseModel(
            title: "SwiftUI for Beginners",
            slug: "swiftui-beginners",
            tags: ["swiftui", "ios", "ui", "beginner"],
            description: "Create beautiful iOS apps with SwiftUI. No prior experience needed.",
            status: StatusEnum.published.rawValue,
            price: PriceEnum.free.rawValue,
            headerImage: URL(string: "https://example.com/images/swiftui-course.jpg"),
            article: "Learn to build modern iOS interfaces with SwiftUI's declarative syntax.",
            topHexColor: "#F093FB",
            bottomHexColor: "#F5576C",
            syllabus: URL(string: "https://example.com/syllabus/swiftui.pdf"),
            assets: URL(string: "https://example.com/assets/swiftui.zip"),
            author: "John Doe",
            createdAt: Date(),
            updatedAt: Date(),
            publishDate: Date()
        )

        try await swiftCourse.save(on: database)
        try await vaporCourse.save(on: database)
        try await swiftUICourse.save(on: database)

        // Create Guides
        let swiftGuide = GuideModel(
            title: "Swift Best Practices Guide",
            description: "Learn industry-standard Swift coding practices and conventions.",
            headerImage: URL(string: "https://example.com/images/swift-guide.jpg"),
            price: PriceEnum.free.rawValue,
            status: StatusEnum.published.rawValue,
            author: "John Doe",
            slug: "swift-best-practices",
            tags: ["swift", "best-practices", "coding-standards"],
            publishDate: Date(),
            createdAt: Date(),
            updatedAt: Date()
        )

        let apiGuide = GuideModel(
            title: "RESTful API Design Guide",
            description: "Complete guide to designing and building RESTful APIs.",
            headerImage: URL(string: "https://example.com/images/api-guide.jpg"),
            price: PriceEnum.free.rawValue,
            status: StatusEnum.published.rawValue,
            author: "Jane Smith",
            slug: "restful-api-design",
            tags: ["api", "rest", "backend", "web-services"],
            publishDate: Date(),
            createdAt: Date(),
            updatedAt: Date()
        )

        let testingGuide = GuideModel(
            title: "iOS Testing Strategies",
            description: "Master unit testing, UI testing, and TDD in iOS development.",
            headerImage: URL(string: "https://example.com/images/testing-guide.jpg"),
            price: PriceEnum.pro.rawValue,
            status: StatusEnum.published.rawValue,
            author: "Jane Smith",
            slug: "ios-testing-strategies",
            tags: ["testing", "tdd", "ios", "quality-assurance"],
            publishDate: Date(),
            createdAt: Date(),
            updatedAt: Date()
        )

        try await swiftGuide.save(on: database)
        try await apiGuide.save(on: database)
        try await testingGuide.save(on: database)

        // Create Articles
        let article1 = ArticleModel(
            title: "Understanding Swift Optionals",
            slug: "understanding-swift-optionals",
            excerp: "Optionals are one of Swift's most powerful features. Learn how to use them effectively.",
            content: "Swift optionals are a fundamental concept that every iOS developer must master. An optional represents a value that may or may not exist. This article explores optional binding, optional chaining, and best practices...",
            guide: try swiftGuide.requireID(),
            headerImage: URL(string: "https://example.com/images/optionals.jpg"),
            author: "John Doe",
            status: StatusEnum.published.rawValue,
            price: PriceEnum.free.rawValue,
            role: ContentRoleEnum.article.rawValue,
            createdAt: Date(),
            updatedAt: Date(),
            publishDate: Date(),
            tags: ["swift", "optionals", "beginner"]
        )

        let article2 = ArticleModel(
            title: "Building Your First API with Vapor",
            slug: "building-first-api-vapor",
            excerp: "Step-by-step guide to creating a REST API using Vapor framework.",
            content: "Vapor makes it easy to build powerful server-side Swift applications. In this tutorial, we'll create a complete REST API from scratch, including authentication, database integration, and deployment...",
            guide: try apiGuide.requireID(),
            headerImage: URL(string: "https://example.com/images/vapor-api.jpg"),
            author: "Jane Smith",
            status: StatusEnum.published.rawValue,
            price: PriceEnum.free.rawValue,
            role: ContentRoleEnum.tutorial.rawValue,
            createdAt: Date(),
            updatedAt: Date(),
            publishDate: Date(),
            tags: ["vapor", "api", "swift", "backend"]
        )

        let article3 = ArticleModel(
            title: "XCTest: Unit Testing in iOS",
            slug: "xctest-unit-testing-ios",
            excerp: "Comprehensive guide to writing effective unit tests in iOS applications.",
            content: "Testing is crucial for maintaining code quality. This article covers XCTest framework, test-driven development, and testing best practices for iOS apps...",
            guide: try testingGuide.requireID(),
            headerImage: URL(string: "https://example.com/images/xctest.jpg"),
            author: "Jane Smith",
            status: StatusEnum.published.rawValue,
            price: PriceEnum.pro.rawValue,
            role: ContentRoleEnum.article.rawValue,
            createdAt: Date(),
            updatedAt: Date(),
            publishDate: Date(),
            tags: ["testing", "xctest", "ios", "quality"]
        )

        try await article1.save(on: database)
        try await article2.save(on: database)
        try await article3.save(on: database)

        // Create Sessions (Video lessons for courses)
        let session1 = SessionModel()
        session1.title = "Introduction to Swift"
        session1.mp4URL = URL(string: "https://example.com/videos/swift-intro.mp4")
        session1.hlsURL = URL(string: "https://example.com/videos/swift-intro-hls.m3u8")
        session1.publishDate = Date()
        session1.price = PriceEnum.free.rawValue
        session1.article = "Welcome to Swift programming! In this session, we'll cover the basics and set up your development environment."
        session1.course = try swiftCourse.requireID()
        session1.slug = "introduction-to-swift"

        let session2 = SessionModel()
        session2.title = "Variables and Constants"
        session2.mp4URL = URL(string: "https://example.com/videos/variables.mp4")
        session2.hlsURL = URL(string: "https://example.com/videos/variables-hls.m3u8")
        session2.publishDate = Date()
        session2.price = PriceEnum.free.rawValue
        session2.article = "Learn the difference between var and let, and understand Swift's type system."
        session2.course = try swiftCourse.requireID()
        session2.slug = "variables-and-constants"

        let session3 = SessionModel()
        session3.title = "Setting Up Vapor"
        session3.mp4URL = URL(string: "https://example.com/videos/vapor-setup.mp4")
        session3.hlsURL = URL(string: "https://example.com/videos/vapor-setup-hls.m3u8")
        session3.publishDate = Date()
        session3.price = PriceEnum.pro.rawValue
        session3.article = "Install Vapor and create your first server-side Swift project."
        session3.course = try vaporCourse.requireID()
        session3.slug = "setting-up-vapor"

        let session4 = SessionModel()
        session4.title = "Creating Routes and Controllers"
        session4.mp4URL = URL(string: "https://example.com/videos/routes-controllers.mp4")
        session4.hlsURL = URL(string: "https://example.com/videos/routes-controllers-hls.m3u8")
        session4.publishDate = Date()
        session4.price = PriceEnum.pro.rawValue
        session4.article = "Build REST API endpoints with Vapor's routing system."
        session4.course = try vaporCourse.requireID()
        session4.slug = "routes-and-controllers"

        try await session1.save(on: database)
        try await session2.save(on: database)
        try await session3.save(on: database)
        try await session4.save(on: database)
    }

    func revert(on database: Database) async throws {
        // Delete all seeded data
        try await SessionModel.query(on: database).delete()
        try await ArticleModel.query(on: database).delete()
        try await GuideModel.query(on: database).delete()
        try await CourseModel.query(on: database).delete()
    }
}
