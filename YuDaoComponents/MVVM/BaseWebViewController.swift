//
//  BaseWebViewController.swift
//  YuDaoComponents
//
//  Created by mh on 2018/9/3.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import WebKit
import NJKWebViewProgress
import RxSwift
import RxCocoa
import SnapKit

/// 网页浏览器基类-view model
open class BaseWebViewControllerViewModel: BaseViewControllerViewModel {
    
    /// 请求地址，是否转义
    public let urlStr = Variable<String?>(nil)
    
}

/// 网页浏览器基类
open class BaseWebViewController: BaseViewController {
    
    // MARK: - 属性

    /// 是否要转译
    public final var encodeParams = true
    
    /// webview
    @IBOutlet public weak var webView: WKWebView?
    
    /// 点击返回按钮后退（需要设置按钮样式）
    public var isEnableGoBackButton = false {
        didSet {
            if isEnableGoBackButton {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(didCLickBackButton))

            } else {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    /// 回退后刷新，isEnableGoBackButton开启时判断，默认打开
    public var refreshWhenBack = true
    
    /// 返回按钮样式
    open var backButtonImage: UIImage? {
        return nil
    }
    
    /// 后退的网页
    fileprivate var backNavigation: WKNavigation?
    /// 完成首次加载
    fileprivate var isFinishLoad = false
    
    /// 进度条
    fileprivate var progressView: NJKWebViewProgressView?
    
    /// 加载
    func LoadURL(urlString: String) {
        
        var finalUrlStr = urlString
        
        if encodeParams {
            
            var allowedCharacters = CharacterSet.urlPathAllowed
            allowedCharacters.insert(charactersIn: "!*’();:@&=+$,/?%#[]")
            finalUrlStr = urlString.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
        }
        
        guard let url = URL(string: finalUrlStr) else {
            return
        }
        
        let req = URLRequest(url: url)
        
        _ = self.webView?.load(req)
        self.progressView?.progress = 0.0
        
    }
    
    
    // MARK: - 生命周期
    open override func viewSetup() {
        super.viewSetup()
        
        /// web view config
        let configuretion = WKWebViewConfiguration()
        
        /// web view
        var rect = self.view.bounds
        
        if self.webView == nil {
            let wv = WKWebView(frame: rect, configuration: configuretion)
            wv.navigationDelegate = self
            wv.uiDelegate = self
            self.view.addSubview(wv)
            
            wv.snp.makeConstraints { (maker) in
//                maker.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
                maker.top.equalTo(topLayoutGuide.snp.bottom)
                maker.bottom.equalTo(bottomLayoutGuide.snp.top)
                maker.left.equalToSuperview()
                maker.right.equalToSuperview()
            }
            
            self.webView = wv
        }
        
        /// 进度条
        self.webView?.addObserver(self, forKeyPath: "estimatedProgress", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old], context: nil)
        rect.size.height = 2
        let pv = NJKWebViewProgressView(frame: rect)
        pv.tintColor = mColor(0x0389FF)
        self.view.addSubview(pv)
        pv.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.webView ?? view)
            maker.left.equalTo(self.webView ?? view)
            maker.right.equalTo(self.webView ?? view)
            maker.height.equalTo(2)
        }
        
        self.progressView = pv
        self.progressView?.progress = 0.0
        
    }
    
    override open func viewBindViewModel() {
        super.viewBindViewModel()
        
        if let vm = viewModel as? BaseWebViewControllerViewModel {
            
            Observable.combineLatest(vm.viewWillAppear.asObservable(), vm.urlStr.asObservable()) { (_, url) -> String in
                return url ?? ""
                }
                .filter({ [weak self] (_) -> Bool in
                    return self?.isFinishLoad == false
                })
                .asDriver(onErrorJustReturn: "")
                .drive(onNext: { [weak self] (url) in
                    self?.LoadURL(urlString: url)
                })
                .disposed(by: disposeBag)
        }
        
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        
        webView?.navigationDelegate = nil
        webView?.uiDelegate = nil
        
    }
    
    @objc fileprivate func didCLickBackButton() {
        
        if self.webView?.canGoBack == true {
            backNavigation = self.webView?.goBack()
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}


// MARK: - WKUIDelegate
extension BaseWebViewController: WKUIDelegate {
    
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        completionHandler()
    }
    
}


// MARK: - WKNavigationDelegate
extension BaseWebViewController: WKNavigationDelegate {
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let policy = WKNavigationActionPolicy.allow
        
        if let _ = navigationAction.request.url {
           // url 的特殊处理放在这里
            
        }
        
        decisionHandler(policy)
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // 权限认证
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {

            if challenge.previousFailureCount == 0, let serverTrust = challenge.protectionSpace.serverTrust {

                let credential = URLCredential(trust: serverTrust)
                
                completionHandler(.useCredential, credential);

            } else {
                completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge,nil)
                
            }

        } else {
             completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge,nil)
        }

    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        self.isFinishLoad = true
        
        if navigation == backNavigation && refreshWhenBack {
            backNavigation = nil
            webView.reload()
        }
        
    }
    
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        let err = error as NSError
        if err.code != -999 {   /// 非取消的请求
        }
        
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        mLog("error : \(error.localizedDescription)")
        
    }
    
    
    
}


// MARK: - 进度条监控
extension BaseWebViewController {
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //
        if (keyPath != nil && (keyPath! == "estimatedProgress")) {
            
            if let newProgress = change?[NSKeyValueChangeKey.newKey] as? Double,
                let oldProgress = change?[NSKeyValueChangeKey.oldKey] as? Double {
                
                if newProgress < oldProgress {
                    return
                }
                self.progressView?.setProgress(Float(newProgress), animated: true)

            }
            
        } else {
            
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

