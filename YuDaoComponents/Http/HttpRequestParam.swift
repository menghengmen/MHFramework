//
//  HttpRequestParam.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/29.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import HandyJSON

/// 将任何类转化为请求的协议
public protocol HttpRequestCompatible {
    
    /// 需要指名返回类的类型
    associatedtype ResponseModelClass: HttpResponseModelProtocol
    
    /// URL地址
    func url() -> String
    
    /// http方法
    func method() -> HttpRequestMethod
    
    /// 参数
    func paramsDic() -> [String : Any]?
    
    /// 转为请求对象
    func toDataReuqest() -> HttpDataRequest<ResponseModelClass>
    
}

/// 支持造数据协议
public protocol HttpRequestMockCompatible {
    
    /// 伪造数据文件地址，mock文件是不安全的，所以在使用后最好删掉
    func mockFileName() -> String?
    
    /// 伪造的返回数据，如果有的话，会忽略上面的mockFileName
    func mockDic() -> [String: Any]?
    
}

extension HttpRequestCompatible where Self: HttpRequestMockCompatible {
    
    /// 获取伪造数据
    /// 伪造数据文件类型：.json或.plist
    /// 伪造数据格式：{"mark1":{},"mark2":{}}，mark为自定义值
    ///
    /// - Parameters:
    ///   - mark: 标记字段，会去mock数据中匹配，如果不填取第一个
    /// - Returns: 伪造的返回数据
    @discardableResult
    public func getMockInfo(by mark: String? = nil) -> Any? {
        
        var infoDic: Any? = nil
        
        if let fullJsonDic = mockDic() {
            
            infoDic = fetchMockInfo(from: fullJsonDic, mark: mark)
            
        } else if let fullFileName = mockFileName() {
            
            if fullFileName.hasSuffix(".json") {
                
                let fileName = fullFileName.yd.substring(from: 0, to: fullFileName.count - 5)
                if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                    
                    do {
                        let fileUrl = URL(fileURLWithPath: path)
                        let jsonData = try Data(contentsOf: fileUrl)
                        if let fullJsonDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            infoDic = fetchMockInfo(from: fullJsonDic, mark: mark)
                        }
                        
                    } catch {
                        
                    }
                }
                
            } else if fullFileName.hasSuffix(".plist") {
                
                let fileName = fullFileName.yd.substring(from: 0, to: fullFileName.count - 6)
                if let path = Bundle.main.path(forResource: fileName, ofType: ".plist") {
                    
                    let fileUrl = URL(fileURLWithPath: path)
                    if let jsonDic = NSDictionary(contentsOf: fileUrl) as? [String: Any] {
                        infoDic = fetchMockInfo(from: jsonDic, mark: mark)
                    }
                }
            }
        }
        
        return infoDic
    }
    
    private func fetchMockInfo(from fullJsonDic: [String: Any], mark: String? = nil) -> Any? {
        var infoDic: Any? = nil
        
        if let markValue = mark {
            infoDic = fullJsonDic[markValue]
        } else {
            infoDic = fullJsonDic.values.reversed().first
        }
        
        return infoDic
    }
}

/// 请求参数基类，可以继承于此类，或者在类中手动实现协议
open class HttpBaseRequestParamModel<T: HttpResponseModelProtocol>: HandyJSON, HttpRequestCompatible, HttpRequestMockCompatible {
    
    required public init() {
        
    }
    
    public typealias ResponseModelClass = T
    
    open func url() -> String {
        return ""
    }
    
    
    open func method() -> HttpRequestMethod {
        return .GET
    }
    
    open func paramsDic() -> [String : Any]? {
        return self.toJSON()
    }
    
    open func mockFileName() -> String? {
        return nil
    }
    
    open func mockDic() -> [String : Any]? {
        return nil
    }
    
    open func toDataReuqest() -> HttpDataRequest<ResponseModelClass> {
        
        let req = HttpDataRequest<ResponseModelClass>()
        
        req.url = url()
        req.method = method()
        req.originParams = paramsDic()
        
        return req
    }
    
}
