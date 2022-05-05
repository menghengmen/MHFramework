//
//  RefreshEmptyView.swift
//  YuDaoComponents
//
//  Created by mh on 2018/9/18.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//
//  带下拉刷新的空提示view

import Foundation
import SnapKit
import MJRefresh

/// 带下拉刷新的空提示view
public class RefreshEmptyView: UIView {
    
    // MARK: - Public Property
    
    //// 是否开启下拉刷新
    public var isEnablePullRefresh = false {
        didSet {
            if isEnablePullRefresh {
                contentScrollView.mj_header = MJRefreshGifHeader(refreshingBlock: { [weak self] in
                    self?.didCallRefresh?()
                })
                contentScrollView.isScrollEnabled = true
            } else {
                contentScrollView.mj_header = nil
                contentScrollView.isScrollEnabled = false
            }
        }
    }
    
    /// 下拉刷新回调
    public var didCallRefresh: (() -> Void)?
    
    /// 背景图片
    public var backgroundImage: UIImage? {
        get {
            return bgImageView.image
        } set {
            bgImageView.image = newValue
        }
    }
    
    /// 中心图片
    public var centerImage: UIImage? {
        get {
            return centerImageView.image
        } set {
            centerImageView.image = newValue
        }
    }
    
    /// 提示文字
    public var noticeText: String? {
        get {
            return textLbl.text
        } set {
            textLbl.text = newValue
        }
    }
    
    /// 提示文字颜色
    public var noticeTextColor: UIColor {
        get {
            return textLbl.textColor
        } set {
            textLbl.textColor = newValue
        }
    }
    
    /// 提示文字字体
    public var noticeTextFont: UIFont {
        get {
            return textLbl.font
        } set {
            textLbl.font = newValue
        }
    }
    
    // MARK: - Private Property
    
    private let contentScrollView = UIScrollView()
    private let bgImageView = UIImageView()
    private let centerImageView = UIImageView()
    private let textLbl = UILabel()

    // MARK: - Public Method

    /// 结束刷新
    public func callEndRefresh() {
        
        contentScrollView.mj_header?.endRefreshing()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commontInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commontInit()
    }
    
    // MARK: - Private Method
    /// 初始化
    private func commontInit() {
        
        /// 容器scroll view
        addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        contentScrollView.backgroundColor = .clear
        
        /// 背景bg
        contentScrollView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalToSuperview()
        }
        
        /// 中心图片
        contentScrollView.addSubview(centerImageView)
        centerImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-20)
        }
        
        /// 文字
        contentScrollView.addSubview(textLbl)
        textLbl.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalTo(centerImageView.snp.bottom).offset(10)
        }
        textLbl.textAlignment = .center
        textLbl.numberOfLines = 0
        
        self.isEnablePullRefresh = false
        
    }
    
    
}
