//
//  String+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit

/// Extend String with `ew` proxy.
extension String: YuDaoExtesionable { }

extension YuDaoExtesion where Base == String {
    
    /// base 64 转码
    public func base64String() -> String? {
        
        return base.data(using: .utf8)?.base64EncodedString()
    }
    
    /// 加密的手机号，例如133****1234
    public func securityPhone() -> String {
        return replace(from: 3, to: 7, with: "****")
    }
    
    /// 转换为通知名
    public var notificationName: Notification.Name {
        return Notification.Name(rawValue: base)
    }
    
    /// 转换为json字典
    public var jsonDictionary: [String: Any]? {
        
        guard let data = base.data(using: String.Encoding.utf8) else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
    
    /// 转int值，可空
    public var int: Int? {
        return Int(base)
    }
    
    /// 转int值，默认0
    public var intValue: Int {
        return int ?? 0
    }
    
    /// 转int64值，可空
    public var int64: Int64? {
        return Int64(base)
    }
    
    /// 转int64值，默认0
    public var int64Value: Int64 {
        return int64 ?? 0
    }
    
    /// 转Double值，可空
    public var double: Double? {
        return Double(base)
    }
    
    /// 转Double值，默认0
    public var doubleValue: Double {
        return Double(base) ?? 0
    }
    
    /// 转时间戳（毫秒）
    public func timeString(withFormatter format: DateFormatter? = nil) -> String? {
        return int64?.yd.timeString(withFormatter: format)
    }
    
    /// 格式化时间转Date，默认yyyy-MM-dd HH:mm:ss
    public func date(with formatString: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let format = DateFormatter()
        format.dateFormat = formatString
        
        return format.date(from: base)
    }
    
    /// 截取字符串，超过边界时返nil
    ///
    /// - Parameters:
    ///   - startInt: 开始位置
    ///   - endInt: 结束位置（不包含该位置）
    /// - Returns: 截取的字符串
    public func substring(from startInt: Int, to endInt: Int) -> String? {
        
        guard startInt >= 0 && startInt < base.count else {
            return nil
        }
        guard endInt > 0 && endInt <= base.count else {
            return nil
        }
        guard startInt < endInt else {
            return nil
        }
        
        let startIndex = base.index(base.startIndex, offsetBy: startInt)
        let endIndex = base.index(base.startIndex, offsetBy: endInt)
        return String(base[startIndex..<endIndex])
        
    }
    
    /// 截取字符串，不会超过边界
    ///
    /// - Parameters:
    ///   - startInt: 开始位置
    ///   - endInt: 结束位置（不包含该位置）
    /// - Returns: 截取的字符串
    public func substringValue(from startInt: Int, to endInt: Int) -> String {
        
        var startIntValue = startInt
        var endIntValue = endInt
        
        guard startIntValue < base.count else {
            return ""
        }
        guard endIntValue > 0  else {
            return ""
        }
        guard startIntValue < endIntValue else {
            return ""
        }
        
        
        if startInt < 0 {
            startIntValue = 0
        } else if startInt >= base.count {
            startIntValue = base.count - 1
        }
        
        if endInt < 0 {
            endIntValue = 0
        } else if endInt > base.count {
            endIntValue = base.count
        }
        
        //        if endIntValue <= startIntValue {
        //            endIntValue = startIntValue + 1
        //        }
        
        let startIndex = base.index(base.startIndex, offsetBy: startIntValue)
        let endIndex = base.index(base.startIndex, offsetBy: endIntValue)
        return String(base[startIndex..<endIndex])
    }
    
    /// 替换字符串，不会超过边界
    ///
    /// - Parameters:
    ///   - startInt: 开始位置
    ///   - endInt: 结束位置（不包含该位置）
    ///   - string: 用来替换的字符串
    /// - Returns: 处理完的字符串
    public func replace(from startInt: Int, to endInt: Int, with string: String) -> String {
        var startIntValue = startInt
        var endIntValue = endInt
        
        guard startIntValue < base.count else {
            return ""
        }
        guard endIntValue > 0  else {
            return ""
        }
        guard startIntValue < endIntValue else {
            return ""
        }
        
        
        if startInt < 0 {
            startIntValue = 0
        } else if startInt >= base.count {
            startIntValue = base.count - 1
        }
        
        if endInt < 0 {
            endIntValue = 0
        } else if endInt > base.count {
            endIntValue = base.count
        }
        
        
        let startIndex = base.index(base.startIndex, offsetBy: startIntValue)
        let endIndex = base.index(base.startIndex, offsetBy: endIntValue)
        
        return base.replacingCharacters(in: startIndex..<endIndex, with: string)
    }
    
    
    /// 返回一个子字符串的NSRange
    ///
    /// - Parameter subStr: 子字符串
    /// - Returns: NSRange类型的结果，可空
    public func range(of subStr: String) -> NSRange? {
        
        guard let range = base.range(of: subStr) else {
            return nil
        }
        
        let location = base.distance(from: base.startIndex, to: range.lowerBound)
        let length = base.distance(from: range.lowerBound, to: range.upperBound)
        
        return NSMakeRange(location, length)
    }
    
    
    /// 计算字符串完整size
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - limitWidth: 最大宽度
    /// - Returns: 字符串显示的size
    public func size(withFont font: UIFont, limitWidth: CGFloat) -> CGSize {
        
        let normalText: NSString = base as NSString
        let size = CGSize(width: limitWidth, height: CGFloat.greatestFiniteMagnitude)
        
        return normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    
    
    /// 计算字符串完整size
    ///
    /// - Parameters:
    ///   - attributes: 富文本属性
    ///   - limitWidth: 最大宽度
    /// - Returns: 字符串显示的size
    public func size(withAttributes attributes: [NSAttributedString.Key : Any]?, limitWidth: CGFloat) -> CGSize {
        
        let normalText: NSString = base as NSString
        let size = CGSize(width: limitWidth, height: CGFloat.greatestFiniteMagnitude)
        
        return normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
    /// 创建富文本
    ///
    /// - Parameter withAttributes: 富文本属性
    /// - Returns: 返回结果
    public func attrString(withAttributes arrtributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        
        let normalText: NSString = base as NSString
        
        return NSAttributedString(string: normalText as String, attributes: arrtributes)

    }
    
}
