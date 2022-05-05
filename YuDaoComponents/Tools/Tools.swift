//
//  Tools.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/26.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//
// 工具类

import Foundation

// MARK: - 方法简写

/// 系统字体
public func mFont(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

/// 通过Hex色值创建颜色
public func mColor(_ hex: Int, _ alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0, green: CGFloat((hex & 0xFF00) >> 8) / 255.0, blue: CGFloat((hex & 0xFF)) / 255.0, alpha: alpha * 1.0)
}

/// 通过rbga创建颜色
public func mColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha * 1.0)
}

/// 本地化字符串
public func mLocalStr(_ str: String, comment: String = "") -> String {
    return NSLocalizedString(str, comment: comment)
}

/// 调试模式打印，发布后不再打印
public func mLog<T>(_ msg: T) {
#if DEBUG
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
    print("【mLog】【\(dateFormater.string(from: Date()))】\(msg)")
#endif
}

/// 带可选值的比较大小
public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

/// 带可选值的比较大小
public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
