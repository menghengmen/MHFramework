//
//  YuDaoExtesionable.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

public struct YuDaoExtesion<Base>: TypeExtesionable {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol TypeExtesionable {
    associatedtype Base
    var base: Base { get }
    init(_ base: Base)
}

/// A type that has YuDao extensions.
public protocol YuDaoExtesionable {
    /// Extended type
    associatedtype CompatibleType
    
    /// YuDao extensions.
    static var yd: YuDaoExtesion<CompatibleType>.Type { get set }
    
    /// YuDao extensions.
    var yd: YuDaoExtesion<CompatibleType> { get set }
}

extension YuDaoExtesionable {
    /// YuDao extensions.
    public static var yd: YuDaoExtesion<Self>.Type {
        get {
            return YuDaoExtesion<Self>.self
        }
        set {
            // this enables using YuDao to "mutate" base type
        }
    }
    
    /// YuDao extensions.
    public var yd: YuDaoExtesion<Self> {
        get {
            return YuDaoExtesion(self)
        }
        set {
            // this enables using YuDao to "mutate" base object
        }
    }
}

import class Foundation.NSObject

/// Extend NSObject with `YuDao` proxy.
extension NSObject: YuDaoExtesionable { }
