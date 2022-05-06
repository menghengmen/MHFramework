//
//  BaseTableViewController.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

// MARK: - View Model

/// Table View Controller的View Model基类
open class BaseTableViewControllerViewModel: BaseViewControllerViewModel {
    
    /// 刷新数据模式模式
    public enum ReloadDataType {
        /// 主动刷新
        case callReload
        /// 用户下拉刷新
        case userPullRefresh
        /// 用户上拉更多
        case userPushLoadmore
    }
    
    // MARK: - Publick Property
    
    // to view
    
    /// 数据源
    public let dataSource = Variable<[SectionViewModelProtocol]?>(nil)
    
    /// 是否开启下拉刷新
    public let isEnablePullRefresh = Variable<Bool>(false)
    /// 是否开启上拉加载更多
    public let isEnablePushLoadmore = Variable<Bool>(false)
    /// 是否开启编辑Cell
    public let isEnableEditCell = Variable<Bool>(false)
    
    /// 手动开始下拉刷新
    public let callStartPullRefresh = PublishSubject<Void>()
    /// 手动开始上拉更多
    public let callStartPushLoadMore = PublishSubject<Void>()
    
    /// 结束下拉刷新
    public let callEndPullRefresh = PublishSubject<Void>()
    /// 结束上拉更多(是否还有数据)
    public let callEndPushLoadMore = PublishSubject<Bool>()

    /// 主动刷新数据（通过processReloadData自动处理）
    public let callReloadData = PublishSubject<Void>()
    
    /// 滚动到某一行
    public let callScrollToRow = PublishSubject<IndexPath>()
    /// 滚动到顶部
    public let callScrollToTop = PublishSubject<Void>()
    
    // from view
    
    /// 点击一行
    public let didSelectRow = PublishSubject<IndexPath>()
    /// 点击某一个cell（didSelectRow转换而来）
    public let didSelecCell = PublishSubject<TableViewCellViewModelProtocol>()
    /// 提交删除一行
    public let didCommitDeleteRow = PublishSubject<IndexPath>()
    
    /// 触发了下拉刷新
    public let didPullRefresh = PublishSubject<Void>()
    /// 触发了上拉更多
    public let didPushLoadMore = PublishSubject<Void>()
    
    // MARK: - Private Property
    
    /// 处理刷新数据
    fileprivate let mCallProcessReload = PublishSubject<ReloadDataType>()
    /// 刷新table
    fileprivate let mCallReloadTable = PublishSubject<Void>()
    
    // MARK: - Method
    
    public override init() {
        super.init()
        
        dataSource.asObservable()
            .map({ (_) -> Void in })
            .bind(to: mCallReloadTable)
            .disposed(by: disposeBag)
        
        didSelectRow.asObservable()
            .map { [weak self] (idxP) -> TableViewCellViewModelProtocol? in
                return self?.fetchCellViewModel(by: idxP)
            }
            .filter { $0 != nil }
            .map { return $0! }
            .bind(to: didSelecCell)
            .disposed(by: disposeBag)
        
        // 刷新数据处理：
        callReloadData.asObservable()
            .map { ReloadDataType.callReload }
            .bind(to: mCallProcessReload)
            .disposed(by: disposeBag)
        
        didPullRefresh.asObservable()
            .map { ReloadDataType.userPullRefresh }
            .bind(to: mCallProcessReload)
            .disposed(by: disposeBag)
        
        didPushLoadMore.asObservable()
            .map { ReloadDataType.userPushLoadmore }
            .bind(to: mCallProcessReload)
            .disposed(by: disposeBag)
        
        let processFinish = mCallProcessReload.asObservable()
            .flatMapLatest { [weak self] (type) -> Observable<(ReloadDataType, Bool)> in
                return self?.processReloadData(type: type) ?? .empty()
            }
            .share(replay: 1, scope: .whileConnected)
        
        processFinish
            .filter { $0.0 == .userPullRefresh }
            .map { _ in }
            .bind(to: callEndPullRefresh)
            .disposed(by: disposeBag)
        
        processFinish
            .filter { $0.0 == .userPushLoadmore }
            .map { $0.1 }
            .bind(to: callEndPushLoadMore)
            .disposed(by: disposeBag)
        
    }
    
    /// 根据section找到对应的section view model
    public func fetchSectionViewModel(by section: Int) -> SectionViewModelProtocol? {
        return dataSource.value?.yd.element(of: section)
    }
    
    /// 根据indexPath找到对应的cell view model
    public func fetchCellViewModel(by indexPath: IndexPath) -> TableViewCellViewModelProtocol? {
        
        return dataSource.value?.yd.element(of: indexPath.section)?.cellViewModels.yd.element(of: indexPath.row)
    }
    
    /// 重写此方法来处理刷新数据，返回（刷新类型，是否有数据）
    open func processReloadData(type: ReloadDataType) -> Observable<(ReloadDataType, Bool)> {
        
        return .empty()
    }

    
}

// MARK: - View Controller

/// Table View Controller基类，可以使用MVVM
open class BaseTableViewController: BaseViewController {
    
    // MARK: - Property
    
    /// tableview，可以用xib连接，也可以代码创建
    @IBOutlet public weak var tableView: UITableView?
    
    // MARK: - Public Method
    
    /// 子类重写此方法，来指定cell的viewModel对应的view类型
    open func cellClass(from cellViewModel: TableViewCellViewModelProtocol?) -> TableCellCompatible.Type? {
        return BaseTableViewCell.self
    }
    
    /// 子类重写此方法，来指定section的viewModel对应的header view类型，返回空表示无header
    open func sectionHeaderClass(from sectionViewModel: SectionViewModelProtocol?) -> SectionViewCompatible.Type? {
        return nil
    }
    
    /// 子类重写此方法，来指定section的viewModel对应的footer view类型，返回空表示无footer
    open func sectionFooterClass(from sectionViewModel: SectionViewModelProtocol?) -> SectionViewCompatible.Type? {
        return nil
    }
    
    /// 子类重写此方法，在需要自定义时，返回一个的刷新用的header（当开启下拉刷新时）
    open func customRefreshHeaderClass() -> MJRefreshHeader.Type {
        return MJRefreshHeader.self
    }
    
    /// 子类重写此方法，在需要自定义时，返回一个刷新用的footer（当开启上拉更多时）
    open func customRefreshFooterClass() -> MJRefreshFooter.Type {
        return MJRefreshFooter.self
    }
    
    // MARK: - Life Cycle
    
    open override func viewSetup() {
        super.viewSetup()
        
        /// table view 初始化
        if tableView == nil {   // 如果没有通过iboutlet连接，那么创建一个
            let aTableView = UITableView(frame: view.bounds, style: .plain)
            view.addSubview(aTableView)
            
            aTableView.separatorStyle = .none
            aTableView.dataSource = self
            aTableView.delegate = self
            
            tableView = aTableView
        }
        
    }
    
    open override func viewBindViewModel() {
        super.viewBindViewModel()
        
        guard let vm = viewModel as? BaseTableViewControllerViewModel else {
            return
        }
        
        /// 启用下拉刷新
        vm.isEnablePullRefresh
            .asDriver()
            .drive(onNext: { [weak self] (value) in
                self?.tableView?.mj_header = value == false ? nil : self?.creatRefreshHeader()
            })
            .disposed(by: disposeBag)
        
        /// 启用上拉更多
        vm.isEnablePushLoadmore
            .asDriver()
            .drive(onNext: { [weak self] (value) in
                self?.tableView?.mj_footer = value == false ? nil : self?.createRefreshFooter()
            })
            .disposed(by: disposeBag)
        
        /// 手动开始下拉刷新
        vm.callStartPullRefresh
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] (_) in
                self?.tableView?.mj_header?.beginRefreshing()
            })
        .disposed(by: disposeBag)
        
        /// 手动开始上拉更多
        vm.callStartPushLoadMore
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] (_) in
                self?.tableView?.mj_footer?.beginRefreshing()
            })
            .disposed(by: disposeBag)
        
        /// 结束下拉刷新
        vm.callEndPullRefresh
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] (_) in
                self?.tableView?.mj_header?.endRefreshing()
                self?.tableView?.mj_footer?.resetNoMoreData()
            })
            .disposed(by: disposeBag)
        
        /// 结束上拉更多
        vm.callEndPushLoadMore
            .asDriver(onErrorJustReturn: (true))
            .drive(onNext: { [weak self] (value) in
                if value {
                    self?.tableView?.mj_footer?.endRefreshing()
                } else {
                    self?.tableView?.mj_footer?.endRefreshingWithNoMoreData()
                }
            })
            .disposed(by: disposeBag)
        
        /// 刷新tableview
        vm.mCallReloadTable
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] (_) in
                self?.tableView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        /// 滚动
        vm.callScrollToRow
            .asDriver(onErrorJustReturn: IndexPath())
            .drive(onNext: { [weak self] (value) in
                self?.tableView?.scrollToRow(at: value, at: UITableView.ScrollPosition.top, animated: true)
            })
            .disposed(by: disposeBag)
        
        vm.callScrollToTop
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] (value) in
                self?.tableView?.contentOffset = CGPoint.zero
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Private Method
    
    /// 创建下拉控件
    private func creatRefreshHeader() -> MJRefreshHeader? {
        
        let headerView = customRefreshHeaderClass().init(refreshingBlock: { [weak self] in
            (self?.viewModel as? BaseTableViewControllerViewModel)?.didPullRefresh.onNext(())
        })
        
        return headerView
    }
    
    /// 创建上拉卡控件
    private func createRefreshFooter() -> MJRefreshFooter? {
        
        let footerView = customRefreshFooterClass().init(refreshingBlock: { [weak self] in
            (self?.viewModel as? BaseTableViewControllerViewModel)?.didPushLoadMore.onNext(())
        })
        
        return footerView
    }
    
}


// MARK: - TableView DataSource, Delegate
extension BaseTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let dataSourceValue = (viewModel as? BaseTableViewControllerViewModel)?.dataSource.value else {
            return 0
        }
        
        return dataSourceValue.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard var sectionVM = (viewModel as? BaseTableViewControllerViewModel)?.fetchSectionViewModel(by: section) else {
            return 0
        }
        
        sectionVM.callReloadSection = { [weak tableView] in
            tableView?.reloadSections([section], with: .none)
        }
        
        return sectionVM.cellViewModels.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard var cellVM = (viewModel as? BaseTableViewControllerViewModel)?.fetchCellViewModel(by: indexPath) else {
            return UITableViewCell()
        }
        
        guard let cellClass = self.cellClass(from: cellVM) else {
            return UITableViewCell()
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellClass.reuseID(with: cellVM))
        
        if cell == nil {
            cell = cellClass.createInstance(with: cellVM)
        }
        
        (cell as? TableCellCompatible)?.updateView(with: cellVM)
        
        cellVM.callReloadCell = { [weak tableView] in
            tableView?.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell ?? UITableViewCell()
        
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let cellVM = (viewModel as? BaseTableViewControllerViewModel)?.fetchCellViewModel(by: indexPath) else {
            return 0
        }
        
        guard let cellClass = self.cellClass(from: cellVM) else {
            return 0
        }
        
        return cellClass.height(with: cellVM, tableSize: tableView.bounds.size)
    }
    
    
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        (viewModel as? BaseTableViewControllerViewModel)?.didSelectRow.onNext(indexPath)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionVM = (viewModel as? BaseTableViewControllerViewModel)?.fetchSectionViewModel(by: section) else {
            return nil
        }
        
        guard let sectionHeaderClass = sectionHeaderClass(from: sectionVM) else {
            return nil
        }
        
        let reuseID = sectionHeaderClass.reuseID(with: sectionVM)
        
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID)
        
        if headerView == nil {
            headerView = sectionHeaderClass.createInstance(with: sectionVM)
        }
        
        (headerView as? SectionViewCompatible)?.updateView(with: sectionVM)
        
        return headerView
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let sectionVM = (viewModel as? BaseTableViewControllerViewModel)?.fetchSectionViewModel(by: section) else {
            return 0
        }
        
        guard let sectionHeaderClass = sectionHeaderClass(from: sectionVM) else {
            return 0
        }
        
        return sectionHeaderClass.height(with: sectionVM, tableSize: tableView.bounds.size)
        
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let sectionVM = (viewModel as? BaseTableViewControllerViewModel)?.fetchSectionViewModel(by: section) else {
            return nil
        }
        
        guard let sectionFooterClass = sectionFooterClass(from: sectionVM) else {
            return nil
        }
        
        let reuseID = sectionFooterClass.reuseID(with: sectionVM)
        
        var footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseID)
        
        if footerView == nil {
            footerView = sectionFooterClass.createInstance(with: sectionVM)
        }
        
        (footerView as? SectionViewCompatible)?.updateView(with: sectionVM)
        
        return footerView
        
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        guard let sectionVM = (viewModel as? BaseTableViewControllerViewModel)?.fetchSectionViewModel(by: section) else {
            return 0
        }
        
        guard let sectionFooterClass = sectionFooterClass(from: sectionVM) else {
            return 0
        }
        
        return sectionFooterClass.height(with: sectionVM, tableSize: tableView.bounds.size)
    }
    
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (viewModel as? BaseTableViewControllerViewModel)?.isEnableEditCell.value ?? false
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return (viewModel as? BaseTableViewControllerViewModel)?.isEnableEditCell.value == true ? "删除" : nil
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (viewModel as? BaseTableViewControllerViewModel)?.didCommitDeleteRow.onNext(indexPath)
        }
    }
    
    
}
