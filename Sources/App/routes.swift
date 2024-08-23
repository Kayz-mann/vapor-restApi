import Fluent
import Vapor

func routes(_ app: Application) throws {

    //auth middleware
    let basicAuthMiddleware = UserModel.authenticator()
    let guardMiddleWare = UserModel.guardMiddleware()
    let protected = app.routes.grouped(basicAuthMiddleware, guardMiddleWare)
    let basicAuthGroup = app.routes.grouped(basicAuthMiddleware)
    
    
    //token auth
    let tokenAuthMiddleWare = TokenModel.authenticator()
    let tokenAuthGroup = app.routes.grouped(tokenAuthMiddleWare, guardMiddleWare)
    
    //Admin auth
    let adminMiddleWare = CheckAdminMiddleware()
    let adminTokenAuthGroup = app.routes.grouped(tokenAuthMiddleWare, adminMiddleWare)
    
    //controllers
    let authController = AuthController()
    let userController = UserController()
    let courseController = CourseController()
    let guideController = GuideController()
    let articleController =  ArticleController()
    let sessionController  =  SessionController()
    
    //registered auth routes
    basicAuthGroup.post("login", use: authController.loginHandler)
    
    //registered user routes
    basicAuthGroup.post("register", use: userController.create)
    tokenAuthGroup.get("profile", use: userController.get)
    tokenAuthGroup.patch("profile", "update", use: userController.update)
    tokenAuthGroup.delete("profile", "delete", use: userController.delete)
    
    
    adminTokenAuthGroup.post("\(RoutesEnum.sessions.rawValue)", use: sessionController.create)
    adminTokenAuthGroup.get("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.get)
    adminTokenAuthGroup.get("\(RoutesEnum.sessions.rawValue)", use: sessionController.getAll)
    adminTokenAuthGroup.patch("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.update)
    adminTokenAuthGroup.delete("\(RoutesEnum.sessions.rawValue)",  "\(RouteParameter.slug.rawValue)", use: sessionController.delete)
    
    
    adminTokenAuthGroup.post("\(RoutesEnum.courses.rawValue)", use: courseController.create)
      adminTokenAuthGroup.get("\(RoutesEnum.courses.rawValue)", "\(RouteParameter.slug.rawValue)", use: courseController.get)
      adminTokenAuthGroup.get("\(RoutesEnum.courses.rawValue)", use: courseController.getAll)
      adminTokenAuthGroup.patch("\(RoutesEnum.courses.rawValue)", "\(RouteParameter.slug.rawValue)", use: courseController.update)
      adminTokenAuthGroup.delete("\(RoutesEnum.courses.rawValue)", "\(RouteParameter.slug.rawValue)", use: courseController.delete)
    
    adminTokenAuthGroup.post("\(RoutesEnum.guides.rawValue)", use: guideController.create)
    adminTokenAuthGroup.get("\(RoutesEnum.guides.rawValue)", "\(RouteParameter.slug.rawValue)", use: guideController.get)
    adminTokenAuthGroup.get("\(RoutesEnum.guides.rawValue)", use: guideController.getAll)
    adminTokenAuthGroup.patch("\(RoutesEnum.guides.rawValue)",  "\(RouteParameter.slug.rawValue)",  use: guideController.update)
    adminTokenAuthGroup.delete("\(RoutesEnum.guides.rawValue)",  "\(RouteParameter.slug.rawValue)", use: guideController.delete)
    
    
    adminTokenAuthGroup.post("\(RoutesEnum.articles.rawValue)", use: articleController.create)
    adminTokenAuthGroup.get("\(RoutesEnum.articles.rawValue)",  "\(RouteParameter.slug.rawValue)", use: articleController.get)
    adminTokenAuthGroup.get("\(RoutesEnum.articles.rawValue)", use: articleController.getAll)
    adminTokenAuthGroup.patch("\(RoutesEnum.articles.rawValue)",  "\(RouteParameter.slug.rawValue)", use: articleController.update)
    adminTokenAuthGroup.delete("\(RoutesEnum.articles.rawValue)",  "\(RouteParameter.slug.rawValue)", use: articleController.delete)


}
