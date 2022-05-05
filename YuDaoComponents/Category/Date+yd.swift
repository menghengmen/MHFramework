//
//  Date+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/11/27.
//  Copyright © 2018 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

/// Extend Date with `yd` proxy.
extension Date: YuDaoExtesionable { }

extension YuDaoExtesion where Base == Date {
    
    /// 毫秒时间戳
    public var timeIntevaleSince1970ms: Int64 {
        return Int64(base.timeIntervalSince1970) * 1000
    }
    
    /// 毫秒时间戳字符串
    public var timeIntevaleSince1970msString: String {
        return "\(Int64(base.timeIntervalSince1970) * 1000)"
    }
    
    /// 格式化时间，默认格式：yyyy-MM-dd HH:mm:ss
    public func timeString(withFormatter formatter: DateFormatter) -> String? {
        return formatter.string(from: base)
    }
    
    /// 格式化时间，默认格式：yyyy-MM-dd HH:mm:ss
    public func timeString(with formatString: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        var fom = DateFormatter()
        fom.dateFormat = formatString
        
        return timeString(withFormatter: fom)
    }
    
}
