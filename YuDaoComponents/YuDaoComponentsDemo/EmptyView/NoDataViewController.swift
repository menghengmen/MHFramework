//
//  noDataViewController.swift
//  YuDaoComponentsDemo
//
//  Created by 哈哈 on 2018/9/13.
//  Copyright © 2018年 Jiangsu Yu Dao Data Technology Co.,Ltd. All rights reserved.
//

import UIKit
import YuDaoComponents
import RxCocoa
import RxSwift
import SnapKit

/// 空提示演示
class NoDataViewController: UIViewController {
    
    /// 从ib加载
    @IBOutlet private var emptyView: RefreshEmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // 从代码加载
//        let emptyView = RefreshEmptyView(frame: view.bounds)
//        view.addSubview(emptyView)
//        emptyView.snp.makeConstraints { (maker) in
//            maker.top.equalTo(topLayoutGuide.snp.bottom)
//            maker.bottom.equalToSuperview()
//            maker.left.equalToSuperview()
//            maker.right.equalToSuperview()
//        }
//
        emptyView.backgroundImage = UIImage(named: "bg_round_w")
        emptyView.centerImage = UIImage(named: "holder_noData")
        emptyView.noticeText = "暂无数据"
        
        
        
    }
}
