//
//  HttpRequest.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/29.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift


// MARK: - 基类请求

/// 请求封装基类
open class HttpRequest<T: HttpResponseModelProtocol>: HttpRequestSendable {
    
    // MARK: - Public
    
    /// 正在请求中，默认no
    public let isRequesting = Variable<Bool>(false)
    /// 传统block回调
    public func response(_ rsp: ((HttpResponse<T>) -> Void)?) {
        response = rsp
    }
    /// rx响应式消息回调
    public var responseRx = PublishSubject<HttpResponse<T>>()
    
    public init() {
        
    }
    
    // MARK: - Private
    
    private var response: ((HttpResponse<T>) -> Void)?
    
    
    // MARK: - HttpRequestSendable
    
    /// url 地址
    open var url: String = ""
    
    /// http请求方式
    open var method: HttpRequestMethod = .GET
    
    /// 额外的头部属性
    open var additionalHeaders: [String : String]? {
        return nil
    }
    
    /// 开始处理
    open func handleStart() {
        isRequesting.value = true
    }
    
    /// 回调处理
    open func handleComplition(jsonObj: Any?, responseCode: Int?, err: Error?) {
        mLog("【Http请求】收到:\(url) code:\(String(describing: responseCode)) err:\(String(describing: err)) rsp:\(String(describing: jsonObj))")
        
        let rsp = HttpResponse<T>(jsonObj: jsonObj, responseCode: responseCode, err: err)
        
        isRequesting.value = false
        response?(rsp)
        responseRx.onNext(rsp)
    }
    
    /// 定制Reuqest，在最终生成的URLRequest基础上修改，替换一个新的
    open func customRequestEdit(request: URLRequest?) -> URLRequest? {
        return nil
    }
}

// MARK: - 数据请求

/// 数据请求封装
open class HttpDataRequest<T: HttpResponseModelProtocol>: HttpRequest<T>, HttpDataRequestSendable {
    
    // MARK: - Public
    
    /// 原始参数
    open var originParams: [String : Any]?
    
    override public init() {
        super.init()
    }
    
    // MARK: - HttpDataRequestSendable
    
    override open var additionalHeaders: [String : String]? {
        return nil
    }
    
    /// 实际发送参数，需要加密请重写
    open var params: [String : Any]? {
        return originParams
    }
    
    override open func handleComplition(jsonObj: Any?, responseCode: Int?, err: Error?) {
        
        super.handleComplition(jsonObj: jsonObj, responseCode: responseCode, err: err)
    }
    
    override open func handleStart() {
        super.handleStart()
        
        mLog("【Http请求】发送:\(url), param：\(originParams ?? [:]) header: \(additionalHeaders ?? [:])")
        
    }
    
    
}

// MARK: - 上传请求

/// 上传请求封装类
open class HttpUploadRequest<T: HttpResponseModelProtocol>: HttpRequest<T>, HttpUploadRequestSendable {
    
    /// 上传内容
    open var multipartFormDatas: [HttpUploadDataCompatible] = [UploadFileUnit]()
    
    override open var additionalHeaders: [String : String]? {
        
        return nil
    }
    
    override public init() {
        super.init()
        
        method = .POST
    }
}

/// 上传数据模型
public struct UploadFileUnit: HttpUploadDataCompatible {
    
    /// 需要上传数据data
    public var uploadFileData: Data? = nil
    /// 需要上传数据地址，如果设置了uploadFileData，忽略这个
    public var uploadFileUrl: URL? = nil
    /// 组装的name字段
    public var name: String = ""
    /// 组装的fileName字段
    public var fileName: String?
    /// 组装的mimeType字段
    public var mimeType: String?
    
    public init() {

    }
    
}



