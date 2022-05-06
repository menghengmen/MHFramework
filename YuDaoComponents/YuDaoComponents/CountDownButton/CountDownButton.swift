//
//  CountDownButton.swift
//  YuDaoComponents
//
//  Created by mh on 2018/8/8.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//
//  倒计时按钮

import Foundation
import UIKit

/// 倒计时按钮
public class CountDownButton: UIButton {
    
    // MARK: - Public Property
    
    /// 倒计时结束后的文字
    public var readyText: String = ""
    
    /// 正在倒计时中
    public var isCountDowning: Bool { return timer?.isValid == true }
    
    /// 点击按钮回调
    public var buttonTap: (() -> Void)?
    /// 倒计时改变回调
    public var secnodChanged: ((_ second: Int) -> Void)?
    /// 结束倒计时回调
    public var countDownFinish: (() -> Void)?
    
    // MARK: - Pirvate Property
    
    private var second: Int?
    private var totalSecond: Int?
    private var timer: Timer?
    private var startDate = Date()
    
    // MARK: - Public Method
    
    /// 手动开始倒计时
    public func startCountDown(with second: Int) {
    
        if isCountDowning {
            return
        }
        
        totalSecond = second
        self.second = totalSecond
        
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        startDate = Date()
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)

        /// 直接触发一次
        timerFire()
    }
    /// 手动结束倒计时
    public func stopCountDown() {
        
        
        if let timerV = timer {
            if timerV.isValid {
                timerV.invalidate()
                second = totalSecond
                
                if countDownFinish != nil {
                    DispatchQueue.main.async { [weak self] in
                        self?.countDownFinish?()
                    }
                }
                
                self.isEnabled = true
                self.setTitle(readyText, for: .normal)
            }
        }
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override func removeFromSuperview() {
        
        timer?.invalidate()
        timer = nil
        
        super.removeFromSuperview()
        
    }
    
    deinit {
        
    }
    
    
    // MARK: - Private Method
    private func commonInit() {
        
        self.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
    }
    
    @objc private func touchButton() {
        
        if buttonTap != nil {
            DispatchQueue.main.async { [weak self] in
                self?.buttonTap?()
            }
        }
    }
    
    @objc private func timerFire() {
        
        let deltaTime = Date().timeIntervalSince(startDate)
        
        second = (totalSecond ?? 0) - Int(deltaTime+0.5)
        
        if (second ?? -1) < 0 {
            self.stopCountDown()
        } else {
            self.isEnabled = false
            if secnodChanged != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.secnodChanged?(self?.second ?? 0)
                }
            }
            
            self.setTitle("\(self.second ?? 0)s", for: .normal)
        }
        
    }

    
}

