//
//  BaseViewController.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// 等待框状态
public class LoadingState {
    
    /// 是否在等待
    public var isLoading = false
    /// 等待的文案
    public var loadingText: String? = nil
    
    /// 没有等待中
    public static var noLoading: LoadingState { return LoadingState(isLoading: false, loadingText: nil) }
    
    public init(isLoading: Bool, loadingText: String? = nil) {
        self.isLoading = isLoading
        self.loadingText = loadingText
    }
    
    public convenience init(loadingInfo: LoadingInfo?) {
        self.init(isLoading: loadingInfo != nil, loadingText: loadingInfo?.text)
    }
}

/// 等待框信息
public class LoadingInfo: Equatable {
    
    /// 等待的文案
    public var text: String? = nil
    /// 等待的超时时间
    public var timeout: TimeInterval? = nil
    /// 超时的错误信息
    public var timeoutError: String? = nil
    
    /// 结束事件，bool值表示是否超时
    public let endLoading = PublishSubject<Bool>()
    
    /// 超时的事件
    private var timeoutRx: Observable<Void>?
    /// 监听回收袋
    private var disposeBag = DisposeBag()
    
    /// 初始化
    public init(text: String? = nil,
         timeout: TimeInterval? = nil,
         timeoutError: String? = nil) {
        
        self.text = text
        self.timeout = timeout
        self.timeoutError = timeoutError
        
    }
    
    /// 调用开始，返回一个超时事件（可能为空）
    public func start() -> Observable<Void> {
        if let timeoutValue = timeout {
            
            /// 发送一个15秒后超时的消息，如果之后收到设备信息更新，则结束等待框，弹出错误提示
            let timeoutRx = Observable.just(())
                .delay(timeoutValue, scheduler: MainScheduler.instance)
            
            /// 持有
            self.timeoutRx = timeoutRx
            
            return timeoutRx
        } else {
            return Observable.empty()
        }
    }
    
    /// 调用结束
    public func end(byTimeout isTimeOut: Bool) {
        
        /// 回收掉超时事件的监听
        disposeBag = DisposeBag()
        timeoutRx = nil
        endLoading.onNext(isTimeOut)
    }
    
    
    // Equatable
    public static func == (lhs: LoadingInfo, rhs: LoadingInfo) -> Bool {
        
        return lhs.text == rhs.text
            && lhs.timeout == rhs.timeout
            && lhs.timeoutError == rhs.timeoutError
    }
    
}

/// 弹框协议，继承于toast协议
public protocol ControllerAlertProtocol: ControllerMessageProtocol {
    /// 重写这个方法，设置弹框样式
    func showAlert(_ message: AlertMessage) -> Observable<(AlertMessage, Int)>
}

extension ControllerAlertProtocol {
    public func toast(_ message: String) {
        _ = showAlert(AlertMessage(message: message, alertType: .toast))
    }
    public func alert(_ message: String) {
        _ = showAlert(AlertMessage(message: message, alertType: .alert))
    }
}

/// 弹框数据
public struct AlertMessage {
    
    /// 提示框类型
    public enum AlertType {
        /// 无
        case none
        /// 弹框
        case alert
        /// toast
        case toast
        /// 自定义
        case custom
    }
    
    /// 提示信息
    public var message: String?
    
    /// 标题
    public var title: String?
    /// 取消按钮标题
    public var cancelButtonTitle: String = "确定"
    /// ok按钮标题
    public var okButtonTitle: String?
    
    /// 提示信息的方式
    public var alertType: AlertType = .none
    
    /// 附加字典
    public var infoDic: [String: Any]?
    
    /// 空白无提示
    public static let noMessage = AlertMessage(alertType: .none)
    
    /// 初始化
    public init(message: String? = nil, alertType: AlertType = .none, title: String? = nil, cancelButtonTitle: String = "确定", okButtonTitle: String? = nil) {
        self.alertType = alertType
        self.title = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        self.okButtonTitle = okButtonTitle
        
        if self.message == nil && self.title == nil { // 空提示
            self.alertType = .none
        }
    }
    
    /// 带两个按钮的alert
    public static func twoButtonAlert(with message: String? = nil) -> AlertMessage {
        return AlertMessage(message: message, alertType: AlertMessage.AlertType.alert, title: nil, cancelButtonTitle: "取消", okButtonTitle: "确定")
    }
    
}

/// 错误提示view
public struct ErrViewInfo: Hashable {
    
    /// 错误类型
    public enum ErrType {
        /// 网络错误
        case network
        /// 无数据
        case nodata
        /// 其他自定义
        case custom
    }
    
    /// 类型
    public var type: ErrType = .network
    
    /// 附带数据
    public var infoDic: [String: AnyHashable]?
    
    /// 初始化
    public init(type: ErrType, infoDic: [String: AnyHashable]? = nil ) {
        self.type = type
        self.infoDic = infoDic
    }
}

// MARK: - View Model

/// ViewController基类的ViewModel
open class BaseViewControllerViewModel: NSObject {
    
    // MARK: - Property
    
    /// rx使用的DisposeBag
    public let disposeBag = DisposeBag()
    
    // event from view
    public let viewDidLoad = PublishSubject<Void>()
    public let viewWillAppear = PublishSubject<Void>()
    public let viewDidAppear = PublishSubject<Void>()
    public let viewWillDisappear = PublishSubject<Void>()
    public let viewDeinit = PublishSubject<Void>()
    
    // event to view
    
    /// 标题
    public let navTitle = Variable<String?>(nil)
    
    /// view的等待框状态
    public let isShowLoading = Variable<LoadingState>(.noLoading)
    /// 开始一项等待，可以叠加，等待文字会显示为最新的等待文字
    public let startOneLoading = PublishSubject<LoadingInfo>()
    /// 结束一项等待（如果传入nil时会结束最早开始的等待），当所有等待都结束时，等待框会消失
    public let endOneLoading = PublishSubject<LoadingInfo?>()
    
    /// 弹框
    public let showMessage = PublishSubject<AlertMessage>()
    /// 点击了带确定和取消的弹框
    public let didConfirmAlert = PublishSubject<(AlertMessage,Int)>()
    /// 错误提示页面
    public let errView = Variable<ErrViewInfo?>(nil)
    /// 点击了错误页面
    public let clickErrView = PublishSubject<ErrViewInfo>()
    
    /// 返回
    public let goBack = PublishSubject<Void>()
    /// 打开路由，参数为页面路由类型和infoDic
    public let openRouter = PublishSubject<RouterInfo>()
    
    // MARK: - Private Property
    
    /// 等待框缓存区
    private var loadingCache = [LoadingInfo]()
    
    
    // MARK: - Life Cycle
    
    public override init() {
        super.init()
        
        startOneLoading.asObservable()
            .observeOn(MainScheduler.instance)
            .map({ [weak self] (value) -> LoadingState in
                return self?.addOneLoading(value) ?? .noLoading
            })
            .bind(to: isShowLoading)
            .disposed(by: disposeBag)
        
        endOneLoading.asObservable()
            .observeOn(MainScheduler.instance)
            .map({ [weak self] (value) -> LoadingState in
                return self?.removeOneLoading(value) ?? .noLoading
            })
            .bind(to: isShowLoading)
            .disposed(by: disposeBag)
        
    }
    
    deinit {
        mLog("view model析构:\(self)")
    }
    
    
    // MARK: - Private Method
    
    /// 添加一个loading
    private func addOneLoading(_ info: LoadingInfo) -> LoadingState {
        
        loadingCache.append(info)
        
        info.start().asObservable()
            .map({ [weak self, weak info] (_) -> LoadingState in
                return self?.removeOneLoading(info, isTimeout: true) ?? .noLoading
            })
            .bind(to: isShowLoading)
            .disposed(by: disposeBag)
        
        return LoadingState(loadingInfo: info)
    }
    
    /// 移除一个loading
    private func removeOneLoading(_ info: LoadingInfo?, isTimeout: Bool = false) -> LoadingState {
        
        if isTimeout {
            loadingTimeout(info)
        }
        
        info?.end(byTimeout: isTimeout)
        
        // 删除
        var idxToRemove: Int? = nil
        
        if let infoValue = info {
            idxToRemove = loadingCache.index(of: infoValue)
        }
        
        if idxToRemove == nil && loadingCache.isEmpty == false {
            idxToRemove = 0 // 删除最早的那个
        }
        
        if let idxToRemoveValue = idxToRemove {
            _ = loadingCache.remove(at: idxToRemoveValue)
        }
        
        return LoadingState(loadingInfo: loadingCache.last)
        
    }
    
    /// 等待框超时的处理
    private func loadingTimeout(_ info: LoadingInfo?) {
        
        if let timeoutErr = info?.timeoutError {
            self.showMessage.onNext(AlertMessage(message: timeoutErr, alertType: .toast))
        }
    }
    
}

// MARK: - View Controller

/// ViewController基类，可以使用MVVM
open class BaseViewController: UIViewController {
    
    // MARK: - Public Property
    
    /// view model，可选
    public var viewModel: BaseViewControllerViewModel? {
        didSet {
            if viewIsLoad {
                viewBindViewModel()
            }
        }
    }
    
    /// 是否加载完毕
    public var viewIsLoad = false
    
    /// rx使用的DisposeBag
    public var disposeBag = DisposeBag()
    
    // MARK: - Public Method
    
    /// 重写这个方法，设置等待框样式
    open func showLoading(withText text: String? = nil) {
        
    }
    
    /// 重写这个方法，设置弹框样式
    open func showAlert(_ message: AlertMessage) -> Observable<(AlertMessage, Int)> {
        
        return .empty()
    }
    
    /// 重写这个方法，隐藏等待框
    open func hideLoading() {
        
    }
    
    /// 重写这个方法，展示错误页面
    open func showErrView(_ info: ErrViewInfo) -> Observable<ErrViewInfo>  {
        
        return .empty()
    }
    
    /// 重写这个方法，移除错误页面
    open func hideErrView() {
        
    }
    
    /// 重写这个方法，在里面初始化相关view，会在ViewDidLoad中，viewBindViewModel之前调用
    open func viewSetup() {
        
    }
    
    /// 重写并在这个方法里绑定view和view model，默认在ViewDidLoad中，viewSetup之后调用
    open func viewBindViewModel() {
        
        /// view model 绑定
        if let viewModel = viewModel {
            
            /// 重制回收袋
            disposeBag = DisposeBag()
            
            /// 等待框
            viewModel.isShowLoading
                .asDriver()
                .drive(onNext: { [weak self] (value) in
                    if value.isLoading {
                        self?.showLoading(withText: value.loadingText)
                    } else {
                        self?.hideLoading()
                    }
                })
                .disposed(by: disposeBag)
            
            /// 带取消和确认的弹框
            viewModel.showMessage.asObservable()
                .observeOn(MainScheduler.instance)
                .delay(0.1, scheduler: MainScheduler.instance) // 避免和等待框结束的冲突
                .flatMap({ [weak self] (value) -> Observable<(AlertMessage, Int)> in
                    return self?.showAlert(value) ?? .empty()
                })
                .bind(to: viewModel.didConfirmAlert)
                .disposed(by: disposeBag)
            
            /// 错误界面
            viewModel.errView.asObservable()
                .filter { $0 != nil }
                .observeOn(MainScheduler.instance)
                .flatMapLatest { [weak self] (value) -> Observable<ErrViewInfo> in
                    return self?.showErrView(value!) ?? .empty()
                }
                .bind(to: viewModel.clickErrView)
                .disposed(by: disposeBag)
            
            viewModel.errView.asDriver()
                .filter { $0 == nil }
                .drive(onNext: { [weak self] (_) in
                    self?.hideErrView()
                })
                .disposed(by: disposeBag)
            
            /// 标题
            viewModel.navTitle
                .asDriver()
                .drive(self.navigationItem.rx.title)
                .disposed(by: disposeBag)
            
            // 返回
            viewModel.goBack
                .asDriver(onErrorJustReturn: ())
                .drive(onNext: { [weak self] (_) in
                    _ = self?.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
            
            /// 页面路由跳转
            viewModel.openRouter
                .asDriver(onErrorJustReturn: ((nil, nil)))
                .drive(onNext: { [weak self] (page,dic) in
                    self?.yd.openRouter(page:page, infoDic: dic)
                })
                .disposed(by: disposeBag)
        }
        
    }
    
    // MARK: - Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        /// view setup
        self.viewSetup()
        
        if viewModel != nil {
            
            /// view绑定viewModel
            self.viewBindViewModel()
        }
        
        viewIsLoad = true
        
        /// viewdidload事件
        viewModel?.viewDidLoad.onNext(())
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.viewWillAppear.onNext(())
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel?.viewDidAppear.onNext(())
        
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        
        self.viewModel?.viewWillDisappear.onNext(())
        
        super.viewWillDisappear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
    }
    
    deinit {
        
        self.viewModel?.viewDeinit.onNext(())
        
        mLog("view controller析构:\(self)")
    }
    
    // MARK: - 界面属性定制
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    // MARK: - 转屏
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // MARK: - Private Method
    
    
}

extension BaseViewController: ControllerAlertProtocol {
    
    
}
