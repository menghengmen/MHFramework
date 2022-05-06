//
//  CalendarController.swift
//  YuDaoComponents
//
//  Created by mh on 2018/9/12.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import UIKit
import FSCalendar
import SnapKit

/// 日历控件
public class CalendarController: UIViewController, FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {
  public  typealias Block = (String)->()
  public  var selectCalendarBlock:Block?
  /// 选择的日期
  public  var chooseTime = String()
  /// 日历结束时间
  public  var maximumDate = Date()
  /// 日历开始时间
  public  var minimumDate = Date()
  /// 周末颜色
  public var weekColor = UIColor()
  ///普通日期颜色
  public var dayNormalColor = UIColor()
  ///头部颜色
  public var headerColor = UIColor()
  ///头部星期颜色
  public var headerWeekColor = UIColor()
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.scrollDirection = .vertical
        calendar.allowsMultipleSelection = true
        calendar.placeholderType = .none
        // 不分页显示
        calendar.pagingEnabled = false
        
        calendar.appearance.headerTitleColor = self.headerColor
        calendar.appearance.weekdayTextColor = self.headerWeekColor
        calendar.appearance.borderRadius = 0
        // 日期是周末的
        calendar.appearance.titleWeekendColor = self.weekColor
        // 选择的颜色
        calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.todayColor = UIColor.white
        calendar.appearance.titleTodayColor = self.dayNormalColor
        calendar.firstWeekday = 1;
        calendar.calendarHeaderView.backgroundColor = UIColor.groupTableViewBackground
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.appearance.subtitleOffset = CGPoint.init(x: 0, y: 7)
        return calendar
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(calendar)
       
        calendar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(64)
            make.width.equalToSuperview()
            make.height.equalTo(self.view.snp.height).offset(-64)
        }
        
    }
    
    
    //MARK:-配置cell
    private func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> CalendarCell {
        let cell:CalendarCell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! CalendarCell
        return cell
    }
    
    
    //MARK:-设置最大日期
    public func maximumDate(for calendar: FSCalendar) -> Date {
        return maximumDate
    }
    
    //MARK:-设置最小日期
    public func minimumDate(for calendar: FSCalendar) -> Date {
        // 返回你设置的最小日期
        return minimumDate
    }
    
    public func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
     public func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {

        return true
    }
    
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    //MARK:-设置标题
    public func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if self.gregorian.isDateInToday(date) {
            return "今天"
        }
        return nil
    }
    
    //MARK:-选择某个日期
     public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        chooseTime = dateFormatter.string(from: date)
        calendar.reloadData()
        configureVisibleCells()
        
        if (selectCalendarBlock != nil) {
            selectCalendarBlock?(chooseTime)
        }
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    //MARK:-绘制当前选择的日期
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    public func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        if ((cell as? FSCalendarCell) != nil) {
            return
        }
        
        let rangeCell = (cell as! CalendarCell)
        if position != .current {
            rangeCell.middleLayer.isHidden = true
            rangeCell.selectionLayer.isHidden = true
            return
        }
    }
    
}
