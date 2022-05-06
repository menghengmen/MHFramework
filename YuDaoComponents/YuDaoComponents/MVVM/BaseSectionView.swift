//
//  BaseSectionView.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - 通用协议

/// section view model的协议
public protocol SectionViewModelProtocol {
    
    /// cell view model 数组
    var cellViewModels: [TableViewCellViewModelProtocol] { get set }
    
    /// 主动刷新Section
    var callReloadSection: (() -> Void)? { get set }
}

/// section view（header或footer）的协议
public protocol SectionViewCompatible {
    
    /// 返回一个新建实例
    static func createInstance(with viewModel: SectionViewModelProtocol) -> UITableViewHeaderFooterView?
    
    /// 返回重用ID
    static func reuseID(with viewModel: SectionViewModelProtocol) -> String
    
    /// 计算高度
    static func height(with viewModel: SectionViewModelProtocol, tableSize: CGSize) -> CGFloat
    
    /// 通过view model更新view
    func updateView(with viewModel: SectionViewModelProtocol)
}

// MARK: - 基于通用协议的MVVM基类

/// Section View Model的MVVM基类
open class BaseSectionViewModel: NSObject, SectionViewModelProtocol {
    
    /// 监听关系回收袋
    public var disposeBag = DisposeBag()
    
    /// cell view model 数组
    public var cellViewModels = [TableViewCellViewModelProtocol]()
    
    /// 刷新section回调
    public var callReloadSection: (() -> Void)?
    
    /// 触发刷新的事件
    public let reload = PublishSubject<Void>()
    
    public override init() {
        super.init()
        reload.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.callReloadSection?()
            })
            .disposed(by: disposeBag)
    }
}

/// Section View的MVVM基类
open class BaseSectionView: UITableViewHeaderFooterView, SectionViewCompatible {
    
    /// 监听关系回收袋
    public var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    /// 便捷初始化方法，加载一个xib，放在contentview里
    ///
    /// - Parameters:
    ///   - xibName: xib 名
    ///   - objectIndex: 需要加载的view的index
    public convenience init(xibName: String, reuseIdentifier: String?, objectIndex: Int = 0) {
        self.init(reuseIdentifier: reuseIdentifier)
        
        if let aView = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: self, options: nil).yd.element(of: objectIndex) as? UIView {
            
            aView.frame = contentView.bounds
            aView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.addSubview(aView)
        }
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SectionViewCompatible
    
    open class func createInstance(with viewModel: SectionViewModelProtocol) -> UITableViewHeaderFooterView? {
        return BaseSectionView(reuseIdentifier: BaseSectionView.reuseID(with: viewModel))
    }
    
    open class func reuseID(with viewModel: SectionViewModelProtocol) -> String {
        return "BaseSectionView"
    }
    
    /// 计算高度
    open class func height(with viewModel: SectionViewModelProtocol, tableSize: CGSize) -> CGFloat {
        return 10
    }
    
    /// 通过view model更新view，子类重写时需要调用super方法
    open func updateView(with viewModel: SectionViewModelProtocol) {
        disposeBag = DisposeBag()
    }
    
}
