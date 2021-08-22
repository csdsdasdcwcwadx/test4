import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let userController = UserController()
    let informationController=InformationController()
    let passwordProtected = app.grouped(User.authenticator(),User.guardMiddleware())
    let tokenProtected = app.grouped(UserToken.authenticator(),UserToken.guardMiddleware())

    
    //修改密碼
    app.put("user",":userId", use:userController.update)//ok
    
    //用手機號碼尋找id
    app.post("finduser", use: userController.finduser)
    
    //第一次上傳個人資料
    app.post("information", use:informationController.create)//ok
    
    //更新個人資料
    app.put("information", use:informationController.update)//ok
    
    //註冊
    app.post("signup", use:userController.signup)//ok
    
    //登陸
    passwordProtected.post("login",use: userController.login)//ok
    
    //登陸後收到個人資料
    tokenProtected.get("getperinfo",use: userController.getperinfo)//ok
    
    //收到他人資料
    app.get("otherperinfo",":userId",use:informationController.otherperinfo)//
    
    //登出
    app.delete("logout",":user_tokensId", use: userController.logout)
    
    //更新用戶位址
    app.put("changelocation",use: informationController.changelocation)
    
    //取得範圍內用戶資訊
    app.post("gis", use: informationController.gis)
    

    
}
    
    





