//
//  MvvmDemoVC.swift
//  YuDaoComponentsDemo
//
//  Created by WangXun on 2018/12/25.
//  Copyright © 2018 Jiangsu Yu Dao Data Technology Co.,Ltd. All rights reserved.
//

import Foundation
import YuDaoComponents
import RxCocoa
import RxSwift
import MJRefresh

/// 演示MVVM ViewController
class MvvmDemoVM : BaseTableViewControllerViewModel {
    
    override init() {
        super.init()
        isEnablePullRefresh.value = true
        isEnablePushLoadmore.value = true
    }
    
    override func processReloadData(type: BaseTableViewControllerViewModel.ReloadDataType) -> Observable<(BaseTableViewControllerViewModel.ReloadDataType, Bool)> {
        
        switch type {
        case .userPullRefresh:
            
            return Observable
                .just((type, true))
                .asObservable()
                .delay(1, scheduler: MainScheduler.instance)
            
        case .userPushLoadmore:
            
            return Observable
                .just((type, false))
                .asObservable()
                .delay(2, scheduler: MainScheduler.instance)
            
        case .callReload:
            return .empty()
        }
        
    }
    
}

/// 演示MVVM ViewController
class MvvmDemoVC: BaseTableViewController {
    
    override func customRefreshHeaderClass() -> MJRefreshHeader.Type {
        return MJRefreshStateHeader.self
    }
    
    override func customRefreshFooterClass() -> MJRefreshFooter.Type {
        return MJRefreshAutoNormalFooter.self
    }
    
    
}
