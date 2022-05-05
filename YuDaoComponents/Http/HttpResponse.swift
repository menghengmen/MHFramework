//
//  HttpResponse.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/29.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import HandyJSON

/// 返回类封装
public class HttpResponse<T: HttpResponseModelProtocol>: NSObject {
    
    /// 系统网络响应码
    public var sysCode: Int?
    /// 系统错误消息
    public var sysErrMessage: String?
    /// 返回的json
    public var fullJson: Any?
    /// 返回的josn自动解析的模型
    public var model: T?
    
    /// 初始化
    init(jsonObj: Any?, responseCode: Int?, err: Error?) {
        
        sysCode = responseCode
        sysErrMessage = err?.localizedDescription
        fullJson = jsonObj
        
        if sysCode == nil, let nsErr = err as? NSError {
            sysCode = nsErr.code
        }
        
        if let jsonDic = jsonObj as? [String: Any] {
            
            if let S = T.self as? HandyJSON.Type {
                self.model =  S.deserialize(from: jsonDic) as? T
            } else {
                self.model = T.instance(fromDic: jsonDic) as? T
            }
        }
        
    }
    
    /// 是否成功
    public func isSuccess() -> Bool {
        if sysCode == 200 {
            return model?.isSuccess() ?? false
        } else {
            return false
        }
    }
    
    /// 错误信息，优先显示接口返回的，不展示系统错误信息
    public func errorMsg() -> String? {
        if isSuccess() == false {
            return model?.message()
        }
        return nil
    }
    
}
