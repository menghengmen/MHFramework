//
//  CalendarCell.swift
//  YuDaoComponents
//
//  Created by mh on 2018/9/12.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import UIKit
import FSCalendar

public class CalendarCell: FSCalendarCell {
    
    weak var selectionLayer: CALayer!
    weak var middleLayer: CALayer!
    
    required public init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionLayer = CALayer()
        selectionLayer.backgroundColor = mColor(0x3e5cff, 1).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer

        let middleLayer = CALayer()
        middleLayer.backgroundColor = mColor(0xd2e5fc, 0.3).cgColor
        middleLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(middleLayer, below: self.titleLabel!.layer)
        self.middleLayer = middleLayer
        // false很关键默认选择有 true 默认选择有无
        self.shapeLayer.isHidden = false
        
    }
    
    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.selectionLayer.frame = self.contentView.bounds
        self.middleLayer.frame = self.contentView.bounds
        
    }
    
}
