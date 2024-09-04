

import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    // Auth Middleware
    let basicAuthMiddleware = UserModel.authenticator()
    let tokenAuthMiddleware = TokenModel.authenticator()
    let guardMiddleware = UserModel.guardMiddleware()
    
    // Route Groups
    let basicAuthGroup = app.routes.grouped(basicAuthMiddleware)
    let tokenAuthGroup = app.routes.grouped(tokenAuthMiddleware, guardMiddleware)
    
    // Admin Middleware
    let adminMiddleware = CheckAdminMiddleware()
    let adminTokenAuthGroup = app.routes.grouped(tokenAuthMiddleware, adminMiddleware)
    
    // Student Middleware
    let studentMiddleware = CheckStudentMiddleware()
    let studentTokenAuthGroup = app.routes.grouped(tokenAuthMiddleware, studentMiddleware)
    
    // Controllers
    let authController = AuthController()
    let userController = UserController()
    let courseController = CourseController()
    let guideController = GuideController()
    let articleController = ArticleController()
    let sessionController = SessionController()
    
    // Authentication Routes
    basicAuthGroup.post("login", use: authController.loginHandler)
    
    // User Routes
    basicAuthGroup.post("users", "\(RoutesEnum.register.rawValue)", use: userController.create)
//    app.post("users", "\(RoutesEnum.register.rawValue)", use: userController.create)

    tokenAuthGroup.get("users", "verify", ":id", use: userController.verify)
    tokenAuthGroup.get("users", "\(RoutesEnum.profile.rawValue)", use: userController.get)
    tokenAuthGroup.patch("users", "\(RoutesEnum.profile.rawValue)", "\(RoutesEnum.update.rawValue)", use: userController.update)
    tokenAuthGroup.delete("users", "\(RoutesEnum.profile.rawValue)", "\(RoutesEnum.delete.rawValue)", use: userController.delete)
    
    // Course Routes
    let coursesGroup = app.routes.grouped("users", "\(RoutesEnum.courses.rawValue)")
    coursesGroup.get(use: courseController.getAllObjects)
    coursesGroup.get(":slug", use: courseController.getObject)
    studentTokenAuthGroup.get("users", "\(RoutesEnum.courses.rawValue)", ":slug", "session", ":articleSlug", use: sessionController.getSelectedObject)
//    
//    // Guide Routes
    let guidesGroup = app.routes.grouped("users", "\(RoutesEnum.guides.rawValue)")
    guidesGroup.get(use: guideController.getAllObjects)
    guidesGroup.get(":slug", use: guideController.getObject)
    studentTokenAuthGroup.get("users", "\(RoutesEnum.guides.rawValue)", ":slug", "article", ":articleSlug", use: articleController.getSelectedObject)
//    
//    // Session Routes (Admin)
    let sessionsGroup = adminTokenAuthGroup.grouped("\(RoutesEnum.sessions.rawValue)")
    sessionsGroup.post(use: sessionController.create)
    sessionsGroup.get(":slug", use: sessionController.get)
    sessionsGroup.get(use: sessionController.getAll)
    sessionsGroup.patch(":slug", use: sessionController.update)
    sessionsGroup.delete(":slug", use: sessionController.delete)
    sessionsGroup.get("\(RoutesEnum.status.rawValue)", use: sessionController.getByStatus)
    sessionsGroup.get("\(RoutesEnum.search.rawValue)", use: sessionController.search)
    
    // Course Routes (Admin)
    let adminCoursesGroup = adminTokenAuthGroup.grouped("\(RoutesEnum.courses.rawValue)")
    adminCoursesGroup.post(use: courseController.create)
    adminCoursesGroup.get(":slug", use: courseController.get)
    adminCoursesGroup.get(use: courseController.getAllObjects)
    adminCoursesGroup.patch(":slug", use: courseController.update)
    adminCoursesGroup.delete(":slug", use: courseController.delete)
    adminCoursesGroup.get("\(RoutesEnum.status.rawValue)", use: courseController.getByStatus)
    adminCoursesGroup.get("\(RouteParameter.term)", use: courseController.search)
    
    // Guide Routes (Admin)
    let adminGuidesGroup = adminTokenAuthGroup.grouped("\(RoutesEnum.guides.rawValue)")
    adminGuidesGroup.post(use: guideController.create)
    adminGuidesGroup.get(":slug", use: guideController.get)
    adminGuidesGroup.get(use: guideController.getAll)
    adminGuidesGroup.patch(":slug", use: guideController.update)
    adminGuidesGroup.delete(":slug", use: guideController.delete)
    adminGuidesGroup.get("\(RouteParameter.term)", use: guideController.search)
//    
//    // Article Routes (Admin)
    let adminArticlesGroup = adminTokenAuthGroup.grouped("\(RoutesEnum.articles.rawValue)")
    adminArticlesGroup.post(use: articleController.create)
    adminArticlesGroup.get(":slug", use: articleController.get)
    adminArticlesGroup.get(use: articleController.getAll)
    adminArticlesGroup.patch(":slug", use: articleController.update)
    adminArticlesGroup.delete(":slug", use: articleController.delete)
    adminArticlesGroup.get("\(RoutesEnum.status.rawValue)", use: articleController.getByStatus)
    adminArticlesGroup.get("\(RouteParameter.term)", use: articleController.search)
}






//func routes(_ app: Application) throws {
//
//    //auth middleware
//    let basicAuthMiddleware = UserModel.authenticator()
////    let guardMiddleWare = UserModel.guardMiddleware()
////    let protected = app.routes.grouped(basicAuthMiddleware, guardMiddleWare)
//    let basicAuthGroup = app.routes.grouped(basicAuthMiddleware)
//
//
////    //token auth
////    let tokenAuthMiddleWare = TokenModel.authenticator()
////    let tokenAuthGroup = app.routes.grouped(tokenAuthMiddleWare, guardMiddleWare)
////
////    //Admin auth
////    let adminMiddleWare = CheckAdminMiddleware()
////    let adminTokenAuthGroup = app.routes.grouped(tokenAuthMiddleWare, adminMiddleWare)
////
////    //student auth
////    let studentMiddleWare = CheckStudentMiddleware()
////    let studentTokenAuthGroup =  app.routes.grouped(tokenAuthMiddleWare, studentMiddleWare)
//
//    //controllers
////    let authController = AuthController()
//    let userController = UserController()
////    let courseController = CourseController()
////    let guideController = GuideController()
////    let articleController =  ArticleController()
////    let sessionController  =  SessionController()
//
//    //registered auth routes
////    basicAuthGroup.post("login", use: authController.loginHandler)
//
//    //registered user routes
//    basicAuthGroup.post("users", "\(RoutesEnum.register.rawValue)", use: userController.create)
////    tokenAuthGroup.get("users", "\(RoutesEnum.profile.rawValue)", use: userController.get)
////    tokenAuthGroup.patch("users", "\(RoutesEnum.profile.rawValue)", "\(RoutesEnum.update.rawValue)", use: userController.update)
////    tokenAuthGroup.delete("users","\(RoutesEnum.profile.rawValue)", "\(RoutesEnum.delete.rawValue)", use: userController.delete)
////
////
////
////
////
////    //registered user content routes
////    app.routes.get("users", "\(RoutesEnum.courses.rawValue)", use: courseController.getAllObjects)
////    app.routes.get("users","\(RoutesEnum.courses.rawValue)", "\(RouteParameter.slug.rawValue)", use: courseController.getObject)
////    studentTokenAuthGroup.get("users","\(RoutesEnum.courses.rawValue)", "\(RouteParameter.slug.rawValue)", "session", "\(RouteParameter.article.rawValue)", use: sessionController.getSelectedObject)
////    app.routes.get("users","\(RoutesEnum.guides.rawValue)", use: guideController.getAllObjects)
////    app.routes.get("users","\(RoutesEnum.guides.rawValue)", "\(RouteParameter.slug.rawValue)", use: guideController.getObject)
////    studentTokenAuthGroup.get("users","\(RoutesEnum.guides.rawValue)", "\(RouteParameter.slug.rawValue)", "article", "\(RouteParameter.article.rawValue)", use: articleController.getSelectedObject)
////
////
////    adminTokenAuthGroup.post("\(RoutesEnum.sessions.rawValue)", use: sessionController.create)
////    adminTokenAuthGroup.get("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.get)
////    adminTokenAuthGroup.get("\(RoutesEnum.sessions.rawValue)", use: sessionController.getAll)
////    adminTokenAuthGroup.patch("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.update)
////    adminTokenAuthGroup.delete("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.delete)
////
////
////    adminTokenAuthGroup.post("\(RoutesEnum.courses.rawValue)", use: courseController.create)
////      adminTokenAuthGroup.get("\(RoutesEnum.courses.rawValue)", "\(RouteParameter.slug.rawValue)", use: courseController.get)
////      adminTokenAuthGroup.get("\(RoutesEnum.courses.rawValue)", use: courseController.getAllObjects)
////      adminTokenAuthGroup.patch("\(RoutesEnum.courses.rawValue)", "\(RouteParameter.slug.rawValue)", use: courseController.update)
////      adminTokenAuthGroup.delete("\(RoutesEnum.courses.rawValue)", "\(RouteParameter.slug.rawValue)", use: courseController.delete)
////    adminTokenAuthGroup.get("\(RoutesEnum.courses.rawValue)", "\(RouteParameter.status.rawValue)", use: courseController.getByStatus)
////    adminTokenAuthGroup.get("\(RoutesEnum.courses.rawValue)", "\(RouteParameter.term)", use: courseController.search)
//
////
////
////    adminTokenAuthGroup.post("\(RoutesEnum.guides.rawValue)", use: guideController.create)
////    adminTokenAuthGroup.get("\(RoutesEnum.guides.rawValue)", "\(RouteParameter.slug.rawValue)", use: guideController.get)
////    adminTokenAuthGroup.get("\(RoutesEnum.guides.rawValue)", use: guideController.getAll)
////    adminTokenAuthGroup.patch("\(RoutesEnum.guides.rawValue)",  "\(RouteParameter.slug.rawValue)",  use: guideController.update)
////    adminTokenAuthGroup.delete("\(RoutesEnum.guides.rawValue)",  "\(RouteParameter.slug.rawValue)", use: guideController.delete)
////    adminTokenAuthGroup.get("\(RoutesEnum.guides.rawValue)", "\(RouteParameter.status.rawValue)", use: guideController.getByStatus)
////    adminTokenAuthGroup.get("\(RoutesEnum.guides.rawValue)", "\(RouteParameter.term)", use: guideController.search)
////
////
////
////
////    adminTokenAuthGroup.post("\(RoutesEnum.articles.rawValue)", use: articleController.create)
////    adminTokenAuthGroup.get("\(RoutesEnum.articles.rawValue)",  "\(RouteParameter.slug.rawValue)", use: articleController.get)
////    adminTokenAuthGroup.get("\(RoutesEnum.articles.rawValue)", use: articleController.getAll)
////    adminTokenAuthGroup.patch("\(RoutesEnum.articles.rawValue)",  "\(RouteParameter.slug.rawValue)", use: articleController.update)
////    adminTokenAuthGroup.delete("\(RoutesEnum.articles.rawValue)",  "\(RouteParameter.slug.rawValue)", use: articleController.delete)
////    adminTokenAuthGroup.get("\(RoutesEnum.articles.rawValue)", "\(RouteParameter.status.rawValue)", use: articleController.getByStatus)
////    adminTokenAuthGroup.get("\(RoutesEnum.articles.rawValue)", "\(RouteParameter.term)", use: articleController.search)
////
////
////    adminTokenAuthGroup.post("\(RoutesEnum.sessions.rawValue)", use: sessionController.create)
////    adminTokenAuthGroup.get("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.get)
////    adminTokenAuthGroup.get("\(RoutesEnum.sessions.rawValue)", use: sessionController.getAll)
////    adminTokenAuthGroup.patch("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.update)
////    adminTokenAuthGroup.delete("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.delete)
////    adminTokenAuthGroup.get("\(RoutesEnum.sessions.rawValue)", "\(RouteParameter.status.rawValue)", use: sessionController.getByStatus)
////    adminTokenAuthGroup.get("\(RoutesEnum.sessions.rawValue)", "\(RoutesEnum.search.rawValue)", use: sessionController.search)
//
//
//
//}

