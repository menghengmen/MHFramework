//
//  Double+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/10/30.
//  Copyright © 2018 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

/// Extend Double with `yd` proxy.
extension Double: YuDaoExtesionable { }

extension YuDaoExtesion where Base == Double {
    
    /// 转为String
    public var string: String {        
        return String(base)
    }
    
    /// 格式化时间戳，默认格式：yyyy-MM-dd HH:mm:ss
    public func timeString(withFormatter format: DateFormatter? = nil) -> String? {
        var fom = format
        if fom == nil {
            fom = DateFormatter()
            fom?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        return fom?.string(from: Date(timeIntervalSince1970: base))
    }
    
    /// 四舍五入Int值
    public var roundInt: Int {
        return lround(base)
    }
    
}
