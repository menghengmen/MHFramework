//
//  HttpResponseModel.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/29.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import HandyJSON

/// 返回类的协议
public protocol HttpResponseModelProtocol {
    
    /// 从json对象创建实例
    static func instance(fromDic dic: [String : Any]) -> HttpResponseModelProtocol?
    
    /// 返回码
    func code() -> Int?
    
    /// 返回描述
    func message() -> String?
    
    /// 是否成功
    func isSuccess() -> Bool
}

extension HttpResponseModelProtocol where Self: HandyJSON {
    
    public static func instance(fromDic dic: [String : Any]) -> HttpResponseModelProtocol? {
        return Self.deserialize(from: dic)
    }
}

/// 返回模型基类
open class HttpBaseResponseModel: NSObject, HttpResponseModelProtocol, HandyJSON {
    
    open func code() -> Int? {
        return nil
    }
    
    open func message() -> String? {
        return nil
    }
    
    open func isSuccess() -> Bool {
        return true
    }
    
    /// 映射
    open func mapping(mapper: HelpingMapper) {
        
    }
    
    override required public init() {
        super.init()
    }
    
}
