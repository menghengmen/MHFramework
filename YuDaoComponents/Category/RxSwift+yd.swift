//
//  RxSwift+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - 添加skipNil

extension ObservableType where E == String? {
    
    /// 跳过空值返回一个非可选值
    public func skipNil() -> Observable<String> {
        return filter { $0 != nil }
            .map { $0! }
    }
    
}

extension SharedSequence where E == String? {
    
    /// 跳过空值返回一个非可选值
    public func skipNil() -> SharedSequence<SharingStrategy,String> {
        return filter { $0 != nil }
            .map { $0! }
    }
    
}

extension ObservableType where E == Int? {
    
    /// 跳过空值返回一个非可选值
    public func skipNil() -> Observable<Int> {
        return filter { $0 != nil }
            .map { $0! }
    }
    
}

extension SharedSequence where E == Int? {
    
    /// 跳过空值返回一个非可选值
    public func skipNil() -> SharedSequence<SharingStrategy,Int> {
        return filter { $0 != nil }
            .map { $0! }
    }
    
}

extension ObservableType where E == Bool? {
    
    /// 跳过空值返回一个非可选值
    public func skipNil() -> Observable<Bool> {
        return filter { $0 != nil }
            .map { $0! }
    }
    
}

extension SharedSequence where E == Bool? {
    
    /// 跳过空值返回一个非可选值
    public func skipNil() -> SharedSequence<SharingStrategy,Bool> {
        return filter { $0 != nil }
            .map { $0! }
    }
    
}


// MARK: - 添加replaceEmpty
extension ObservableType where E == String? {
    
    /// 替换字符串空值或可选值
    public func replaceEmpty(_ holder: String) -> Observable<String> {
        return map { $0 == nil ? holder : ($0!.isEmpty ? holder : $0!) }
    }
}

extension SharedSequence where E == String? {
    
    /// 替换字符串空值或可选值
    public func replaceEmpty(_ holder: String) -> SharedSequence<SharingStrategy,String> {
        return map { $0 == nil ? holder : ($0!.isEmpty ? holder : $0!) }
    }
}

extension ObservableType where E == String {
    
    /// 替换字符串空值或可选值
    public func replaceEmpty(_ holder: String) -> Observable<String> {
        return map { $0.isEmpty ? holder : $0 }
    }
    
}

extension SharedSequence where E == String {
    
    /// 替换字符串空值或可选值
    public func replaceEmpty(_ holder: String) -> SharedSequence<SharingStrategy,String> {
        return map { $0.isEmpty ? holder : $0 }
    }
    
}

// MARK: - 添加UITextField - placeholder

extension Reactive where Base: UITextField {
    
    /// Bindable sink for `placeholder` property.
    public var placeholder: Binder<String?> {
        return Binder(self.base) { textfield, holder in
            textfield.placeholder = holder
        }
    }
    
}

extension Reactive where Base: UITextView {
    
    // MARK: - 添加UITextView - editable
    
    /// Bindable sink for `isEditable` property.
    public var isEditable: Binder<Bool> {
        return Binder(self.base) { textView, editable in
            textView.isEditable = editable
        }
    }
    
    // MARK: - 添加UITextView - textColor
    
    /// Bindable sink for `textColor` property.
    public var textColor: Binder<UIColor> {
        return Binder(self.base) { textView, color in
            textView.textColor = color
        }
    }
    
}
