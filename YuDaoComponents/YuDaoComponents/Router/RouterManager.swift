//
//  RouterManager.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import MGJRouter
import RxSwift

///  全局路由管理器
public class RouterManager: NSObject {
    
    /// 单例
    @objc public static let shared = RouterManager()
    
    
    /// 注册路由(通过枚举)
    ///
    /// - Parameters:
    ///   - routerClass: 路由的类型（枚举）
    ///   - handler: 路由的具体处理
    public func registerRouter<T: RouterPageProtocol>(_ routerClass: T.Type, handler: @escaping ((_ type: T, _ paramDic: [String: Any]?) -> RouterCompletionObject)) {
        
        MGJRouter.registerURLPattern(routerClass.baseUrl, toHandler: { (dic) in
            
            guard let type = T.init(type: (dic?["type"] as? String) ?? "") else {
                return
            }
            let paramDic = dic?[MGJRouterParameterUserInfo] as? [String: Any]
            let completionBlock = paramDic?["routerCompletionBlock"] as? ((_: RouterCompletionObject) -> Bool)
            let completionObj = handler(type, paramDic)
            _ = completionBlock?(completionObj)
        })
    }
    
    ///  注册路由(通过字符串)
    ///
    /// - Parameters:
    ///   - routerUrl: 路由地址
    ///   - handler: 路由的具体处理
    public func registerRouter(_ routerUrl: String, handler: @escaping ((_ type: String, _ paramDic: [String: Any]?) -> RouterCompletionObject)) {
        
        MGJRouter.registerURLPattern(routerUrl, toHandler: { (dic) in
            
            let type = (dic?["type"] as? String) ?? ""
            let paramDic = dic?[MGJRouterParameterUserInfo] as? [String: Any]
            let completionBlock = paramDic?["routerCompletionBlock"] as? ((_: RouterCompletionObject) -> Bool)
            let completionObj = handler(type, paramDic)
            _ = completionBlock?(completionObj)
        })
    }
    
    
    /// 注册路由
    ///
    /// - Parameters:
    ///   - routerUrl: 路由地址
    ///   - handler: 路由的具体处理（普通）
    public func registerRouter(_ routerUrl: String, normalHandler: @escaping ((_ type: String, _ paramDic: [String: Any]?) -> Void)) {
        
        MGJRouter.registerURLPattern(routerUrl, toHandler: { (dic) in
            
            let url = (dic?[MGJRouterParameterURL] as? String) ?? ""
            let paramDic = dic?[MGJRouterParameterUserInfo] as? [String: Any]
            
            normalHandler(url, paramDic)
        })
    }
    
    /// 打开一个页面路由
    ///
    /// - Parameters:
    ///   - page: 路由的URL
    ///   - infoDic: 附加的参数
    ///   - complete: 回调处理，返回一个是否处理的bool值
    public func openRouter(page: RouterPageProtocol, infoDic: [String: Any]?, complete: @escaping ((_: RouterCompletionObject) -> Bool)) {
        
        let mgjUrl = MGJRouter.generateURL(withPattern: page.baseUrl, parameters: [page.type])
        self.openRouter(url: mgjUrl ?? "", infoDic: infoDic, complete: complete)
    }
    
    /// 打开一个URL地址路由
    ///
    /// - Parameters:
    ///   - url: 路由的URL字符串
    ///   - infoDic: 附加的参数
    ///   - complete: 回调处理，返回一个是否处理的bool值
    @objc public func openRouter(url: String, infoDic: [String: Any]?, complete: @escaping ((_: RouterCompletionObject) -> Bool)) {
        
        var paramDic = infoDic ?? [String: Any]()
        paramDic["routerCompletionBlock"] = complete
        
        DispatchQueue.main.async {
            MGJRouter.openURL(url, withUserInfo: paramDic, completion: nil)
        }
    }
    
    /// 打开一个URL地址路由
    ///
    /// - Parameters:
    ///   - url: 路由的URL字符串
    ///   - infoDic: 附加的参数
    public func openRouter(url: String, infoDic: [String: Any]?) {
        
        var paramDic = infoDic ?? [String: Any]()
        DispatchQueue.main.async {
            MGJRouter.openURL(url, withUserInfo: paramDic, completion: nil)
        }
    }
    
}
