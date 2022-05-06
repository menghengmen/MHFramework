//
//  UILabel+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/8/1.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {

    /// Bindable sink for `textColor` property.
    public var textColor: Binder<UIColor?> {
        return Binder(base) { label, color in
            label.textColor = color
        }
    }
    
}

