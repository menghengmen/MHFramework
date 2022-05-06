//
//  Array+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

// 这里手动实现了YuDaoExtesionable，因为Array本身是包含一个范型的，所以无法用另一个范型去包含它

public struct YuDaoExtesionArray<Element> {
    
    public let base: Array<Element>
    
    public init(_ base: Array<Element>) {
        self.base = base
    }
}

extension Array {
    
    public var yd: YuDaoExtesionArray<Element> {
        return YuDaoExtesionArray<Element>(self)
    }
}

extension YuDaoExtesionArray {
    
    /// 安全取值
    public func element(of index: Int) -> Element? {
        
        guard index >= 0 && index < base.count else {
            return nil
        }
        
        return base[index]
    }
    
    /// 通过下标安全取值
    public subscript(index: Int) -> Element? {
        
        return element(of: index)
    }
}
