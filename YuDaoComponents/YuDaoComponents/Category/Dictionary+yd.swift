//
//  Dictionary+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

// 这里手动实现了YuDaoExtesionable，因为Dictionary本身是包含一个范型的，所以无法用另一个范型去包含它

public struct YuDaoExtesionDictionary<Key: Hashable, Value> {
    
    public let base: Dictionary<Key, Value>
    
    public init(_ base: Dictionary<Key, Value>) {
        self.base = base
    }
}

extension Dictionary {
    
    public var yd: YuDaoExtesionDictionary<Key, Value> {
        return YuDaoExtesionDictionary<Key, Value>(self)
    }
}


extension YuDaoExtesionDictionary {
    
    /// 转json数据
    public var jsonData: Data? {
        
        do {
            return try JSONSerialization.data(withJSONObject: base, options: [])
        } catch {
            return nil
        }
    }
    
    /// 转json字符串
    public var jsonString: String? {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: base, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
