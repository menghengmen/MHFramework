//
//  CalenderViewPicker.swift
//  YuDaoComponents
//
//  Created by mh on 2018/9/14.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

/// 日历选择控件弹框封装
public class CalenderViewPicker: UIView {
    
    // MARK: - Public Property
    public override init(frame: CGRect) {
       super.init(frame: frame)
    }
    // MARK: - Constants
    private let kDefaultPickerViewHeight: CGFloat = 500 ///view的高度
    private let kDefaultBtnHeight: CGFloat = 40 /// 取消，确定按钮的高度
    private let kDefaultBtnWidth: CGFloat = 40  /// 取消，确定按钮的宽度
    private let kSureButtonTag: Int     = 10   /// 确定按钮的标签

    
    /// 选择日期的回调
    public  typealias Block = (String,String)->()
    public  var selectCalendarBlock:Block?
    /// 日历选择控件
    public let calenderView = CalenderView()
    
    /// 确定/取消按钮颜色
    public var buttonColor: UIColor?
   /// 选择的开始日期
    private var startTime :String?
    /// 选择的结束日期
    private var endTime :String?
    
    /// 从底部弹出展示
    public func show() {
        self.calenderView.selectCalendarBlock = { chooseStartTime,chooseEndTime in
            self.startTime = chooseStartTime
            self.endTime = chooseEndTime
        }
        self.addSubview(calenderView)
        self.setUpUI()

        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: 0, y:200, width:  self.frame.size.width, height: self.kDefaultPickerViewHeight)
            self.calenderView.frame = CGRect(x: 0, y:0, width:  self.frame.size.width, height: self.kDefaultPickerViewHeight)
        }) { (complete) in
        
        }
        
    }
    
    private func setUpUI(){
        var cancelButton = UIButton()
        cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 10, y:10, width:  kDefaultBtnWidth, height: kDefaultBtnHeight)
        cancelButton.setTitle("取消", for: .normal)

        cancelButton.setTitleColor(buttonColor, for: .normal)
        cancelButton.addTarget(self, action:#selector(click(button:)) , for: .touchUpInside)
        self.addSubview(cancelButton)
        
        var sureButton = UIButton()
        sureButton = UIButton(type: .system)
        sureButton.frame = CGRect(x: self.frame.size.width - 50, y:10, width:  kDefaultBtnWidth, height: kDefaultBtnHeight)
        sureButton.tag = kSureButtonTag;
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(buttonColor, for: .normal)
        sureButton.addTarget(self, action:#selector(click(button:)) , for: .touchUpInside)
        self.addSubview(sureButton)
        
    }
    
    @objc func click(button:UIButton) {
       
        if button.tag == kSureButtonTag {
                if (self.selectCalendarBlock != nil) {
                    self.selectCalendarBlock?(startTime ?? "",endTime ?? "")
                }
            
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width:  self.frame.size.width, height: 0)
            
        })
        
    }
    
  
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
