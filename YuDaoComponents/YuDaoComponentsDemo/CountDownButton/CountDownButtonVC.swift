//
//  CountDownButtonVC.swift
//  YuDaoComponentsDemo
//
//  Created by WangXun on 2018/8/8.
//  Copyright © 2018年 Jiangsu Yu Dao Data Technology Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit
import YuDaoComponents

class CountDownButtonVC: UIViewController {
    
    @IBOutlet weak var btnIB: CountDownButton!
    var btnCode: CountDownButton = CountDownButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnIB.readyText = "重新获取"
        
        btnIB.buttonTap = { [weak self] in
            self?.btnIB.startCountDown(with: 10)
        }
        
        btnIB.secnodChanged = { (second) in
            mLog("second:\(second)")
        }
        
        btnIB.countDownFinish = {
            mLog("finish")
        }
        
    }
    
}
