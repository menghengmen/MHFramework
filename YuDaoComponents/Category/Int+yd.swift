//
//  Int+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

/// Extend Int with `yd` proxy.
extension Int: YuDaoExtesionable { }

extension YuDaoExtesion where Base == Int {
    
    /// 转为NSNumber对象
    public var number: NSNumber {
        return NSNumber(value: base)
    }
    
    /// 转为String
    public var string: String {
        return String(base)
    }
    
}

extension Int64: YuDaoExtesionable { }

extension YuDaoExtesion where Base == Int64 {
    
    /// 格式化时间戳（毫秒），默认格式：yyyy-MM-dd HH:mm:ss
    public func timeString(withFormatter format: DateFormatter? = nil) -> String? {
        var fom = format
        if fom == nil {
            fom = DateFormatter()
            fom?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        guard let date = dateByMs() else {
            return nil
        }
        
        return fom?.string(from: date)
    }
    
    /// 格式化时间戳（毫秒）转Date
    public func dateByMs() -> Date? {
        guard let ti = TimeInterval(exactly: base / 1000) else {
            return nil
        }
        
        return Date(timeIntervalSince1970: ti)
    }
    
    /// 转为String
    public var string: String {
        return String(base)
    }
    
}
