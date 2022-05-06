//
//  HttpRequestSender.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/29.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

import Alamofire

// MARK: - 请求发送协议

/// 请求方法类型
public enum HttpRequestMethod: String {
    case GET = "GET"
    case POST  = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case HEAD = "HEAD"
}

/// 支持请求发送的协议
public protocol HttpRequestSendable {
    
    /// 地址
    var url: String { get }
    
    /// 额外的头部
    var additionalHeaders: [String: String]? { get }
    
    /// 方法
    var method: HttpRequestMethod { get }
    
    /// 处理请求开始
    func handleStart()
    
    /// 处理异步回调
    func handleComplition(jsonObj: Any?, responseCode: Int?, err: Error?)
    
    /// 定制Reuqest，在最终生成的URLRequest基础上修改，替换一个新的
    func customRequestEdit(request: URLRequest?) -> URLRequest?
}

/// 支持数据请求发送的协议
public protocol HttpDataRequestSendable: HttpRequestSendable {
    
    /// 参数
    var params: [String: Any]? { get }
}

/// 支持上传请求发送的协议
public protocol HttpUploadRequestSendable: HttpRequestSendable {
    
    /// 需要上传的数据集合
    var multipartFormDatas: [HttpUploadDataCompatible] { get }
}

/// 上传数据格式
public protocol HttpUploadDataCompatible {
    
    /// 需要上传数据data
    var uploadFileData: Data? { get }
    /// 需要上传数据地址，如果设置了uploadFileData，忽略这个
    var uploadFileUrl: URL? { get }
    /// 组装的name字段
    var name: String { get }
    /// 组装的fileName字段（可选）
    var fileName: String? { get }
    /// 组装的fileName字段（可选）
    var mimeType: String? { get }
}

// MARK: - 请求发送类

extension HttpRequestMethod {
    
    /// 转为Alamofire的method
    fileprivate var alamofireHttpMethod: Alamofire.HTTPMethod {
        
        return Alamofire.HTTPMethod(rawValue: rawValue) ?? .get
    }
}

/// 调用Alamofire发送请求的类
public class HttpRequestSender {
    
    /// 单例
    public static let shared = HttpRequestSender()
    
    /// 发送队列，在reuqest组装的时候不要阻塞主线程
    public var sendQueue = DispatchQueue(label: "com.YuDaoComponents.Http.RequestSender.sendQueue")
    
    /// session配置
    public lazy var session: Alamofire.SessionManager = {
        
        /// 基础配置
        let configuration = URLSessionConfiguration.default
        
        /// 默认的头部
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        /// 默认的超时时间
        configuration.timeoutIntervalForRequest = 20
        
        let aSssion = Alamofire.SessionManager(configuration: configuration)
        
        aSssion.startRequestsImmediately = false
        
        return aSssion
    }()
    
    /// 发送一个数据请求
    public func sendDataRequest(_ request: HttpDataRequestSendable) {
        
        request.handleStart()
        
        sendQueue.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in
            var dataReq = self?.session.request(request.url, method: request.method.alamofireHttpMethod, parameters: request.params, encoding: JSONEncoding(), headers: request.additionalHeaders)
            
            if var urlReq = request.customRequestEdit(request: dataReq?.request) {
                dataReq = self?.session.request(urlReq)
            }

            dataReq?.responseJSON { (rsp) in
                
                request.handleComplition(jsonObj: rsp.value, responseCode: rsp.response?.statusCode, err: rsp.error)
            }
            
            dataReq?.resume()
        }
        
    }
    
    /// 发送一个上传数据请求
    public func sendUploadRequest(_ request: HttpUploadRequestSendable) {
        
        request.handleStart()
        
        sendQueue.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in
            
            self?.session.upload(multipartFormData: { (data) in
                
                for aDataUnit in request.multipartFormDatas {
                    if let fileData = aDataUnit.uploadFileData {
                        if let fileName = aDataUnit.fileName, let mimeType = aDataUnit.mimeType {
                            data.append(fileData, withName: aDataUnit.name, fileName: fileName, mimeType: mimeType)
                        } else {
                            data.append(fileData, withName: aDataUnit.name)
                        }
                        
                    } else if let fileUrl = aDataUnit.uploadFileUrl {
                        if let fileName = aDataUnit.fileName, let mimeType = aDataUnit.mimeType {
                            data.append(fileUrl, withName: aDataUnit.name, fileName: fileName, mimeType: mimeType)
                        } else {
                            data.append(fileUrl, withName: aDataUnit.name)
                        }

                    }
                }
                
            }, usingThreshold: Alamofire.SessionManager.multipartFormDataEncodingMemoryThreshold, to: request.url, method: request.method.alamofireHttpMethod, headers: request.additionalHeaders) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { (rsp) in
                        request.handleComplition(jsonObj: rsp.value, responseCode: rsp.response?.statusCode, err: rsp.error)
                    }
                    upload.resume()
                case .failure(let encodingError):
                    request.handleComplition(jsonObj: nil, responseCode: nil, err: encodingError)
                }
            }
        }
    }
    
    /// 发送一个伪造数据请求
    public func sendMockRequest(_ request: HttpDataRequestSendable, infoDic:Any? = nil) {

        request.handleStart()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            request.handleComplition(jsonObj: infoDic, responseCode: 200, err: nil)
        }
        
    }
}
