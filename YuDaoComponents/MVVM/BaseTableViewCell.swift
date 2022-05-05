//
//  BaseTableViewCell.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - 通用协议

/// Cell的ViewModel的协议
public protocol TableViewCellViewModelProtocol {
    
    /// 主动刷新Cell
    var callReloadCell: (() -> Void)? { set get }
    
}

/// cell的协议
public protocol TableCellCompatible {
    
    
    /// 返回一个新建实例
    static func createInstance(with viewModel: TableViewCellViewModelProtocol) -> UITableViewCell
    
    /// 返回重用ID
    static func reuseID(with viewModel: TableViewCellViewModelProtocol) -> String
    
    /// 返回高度
    static func height(with viewModel: TableViewCellViewModelProtocol, tableSize: CGSize) -> CGFloat
    
    /// 更新视图
    func updateView(with viewModel: TableViewCellViewModelProtocol)
    
}

// MARK: - 基于通用协议的MVVM基类

/// Cell View Model的MVVM基类
open class BaseCellViewModel: NSObject, TableViewCellViewModelProtocol {
    
    /// 监听关系回收袋
    public var disposeBag = DisposeBag()
    
    /// 主动刷新Cell
    public var callReloadCell: (() -> Void)?
    
    /// 主动触发的刷新事件
    public let reload = PublishSubject<Void>()
    
    public override init() {
        super.init()
        reload.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.callReloadCell?()
            })
            .disposed(by: disposeBag)
    }
}

/// cell的MVVM基类
open class BaseTableViewCell: UITableViewCell, TableCellCompatible {
    
    /// 监听关系回收袋
    public var disposeBag = DisposeBag()
    
    // MARK: - TableCellCompatible
    
    /// 返回一个新建实例
    open class func createInstance(with viewModel: TableViewCellViewModelProtocol) -> UITableViewCell {
        return BaseTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: BaseTableViewCell.reuseID(with: viewModel))
    }
    
    /// 返回重用ID
    open class func reuseID(with viewModel: TableViewCellViewModelProtocol) -> String {
        return "BaseTableViewCell"
    }
    
    /// 返回高度
    open class func height(with viewModel: TableViewCellViewModelProtocol, tableSize: CGSize) -> CGFloat {
        return 44
    }
    
    /// 更新视图，子类重写时需要先调用super方法
    open func updateView(with viewModel: TableViewCellViewModelProtocol) {
        
        /// 重设之前的绑定关系
        disposeBag = DisposeBag()
    }
    
    deinit {
//        mLog("UITableViewCell析构:\(self)")
    }
}
