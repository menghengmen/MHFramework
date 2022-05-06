//
//  UIViewController+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/30.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit

/// 弹出信息的协议
public protocol ControllerMessageProtocol {
    func toast(_ message: String)
    func alert(_ message: String)
}

// 添加路由功能
extension YuDaoExtesion where Base: UIViewController, Base:ControllerMessageProtocol {
    
    /// 打开页面路由
    ///
    /// - Parameters:
    ///   - page: 具体的页面操作
    ///   - infoDic: 附带的属性
    public func openRouter(page: RouterPageProtocol?, infoDic: [String: Any]?) {
        
        guard let pageValue = page else {
            return
        }
        
        RouterManager.shared.openRouter(page: pageValue, infoDic: infoDic) { [weak base] (completionObj) -> Bool in
            
            return base?.yd.processRouterComplition(completionObj) ?? false
        }
    }
    
    /// 打开页面路由
    ///
    /// - Parameters:
    ///   - page: 具体的地址
    ///   - infoDic: 附带的属性
    public func openRouter(url: String?, infoDic: [String: Any]?) {
        
        guard let urlValue = url else {
            return
        }
        
        RouterManager.shared.openRouter(url: urlValue, infoDic: infoDic) { [weak base] (completionObj) -> Bool in
            
            return base?.yd.processRouterComplition(completionObj) ?? false
        }
    }
    
    /// 处理路由回调
    public func processRouterComplition(_ completionObj: RouterCompletionObject) -> Bool {
        var processResult = true
        
        if let alertStr = completionObj.alertMessage {
            base.alert(alertStr)
        } else if let toastStr = completionObj.toastMessage {
            base.toast(toastStr)
        }
        
        
        switch completionObj.jumpType {
        case .none, .block:
            break;
        case .push:
            if let vc = completionObj.controller {
                base.navigationController?.pushViewController(vc, animated: completionObj.animated)
            } else {
                processResult = false
            }
        case .pop:
            base.navigationController?.popViewController(animated: completionObj.animated)
        case .popToRoot:
            base.navigationController?.popToRootViewController(animated: completionObj.animated)
        case .popToController:
            if let cls = completionObj.popToControllerType {
                var targetVC: UIViewController? = nil
                for vc in base.navigationController?.viewControllers ?? [] {
                    if vc.isKind(of: cls) {
                        targetVC = vc
                        break
                    }
                }
                if let targetVCValue = targetVC {
                    base.navigationController?.popToViewController(targetVCValue, animated: completionObj.animated)
                }
                
            }
        case .modal:
            if let vc = completionObj.controller {
                base.present(vc, animated: completionObj.animated, completion: nil)
            } else {
                processResult = false
            }
        case .dismiss:
            base.dismiss(animated: completionObj.animated, completion: nil)
            
        case .subview:
            if let aSubview = completionObj.view {
                aSubview.frame = base.view.bounds
                aSubview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                base.view.addSubview(aSubview)
            }
        }
        
        return processResult
    }
    
}
