//
//  Data+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

/// Extend Data with `yd` proxy.
extension Data: YuDaoExtesionable { }

extension YuDaoExtesion where Base == Data {
    
    /// 转为json字典
    public var jsonDictionary: [String: Any]? {
        
        do {
            return try JSONSerialization.jsonObject(with: base, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
    
    /// 转uft8字符串
    public var utf8String: String? {
        return String(data: base, encoding: String.Encoding.utf8)
    }
    
}
