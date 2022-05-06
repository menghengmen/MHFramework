//
//  CalenderView.swift
//  YuDaoComponents
//
//  Created by mh on 2018/9/14.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import SnapKit

/// 日历选择控件
public class CalenderView: UIView,FSCalendarDelegate,FSCalendarDataSource {
    
    // MARK: - Public Property
    
    public  typealias Block = (String,String)->()
    public  var selectCalendarBlock:Block?
    
    /// 是否支持选择一段时间
    public var isAllowSelectCrossTime = false
    /// 支持一段时间--开始时间
    public var startTime = String()
    /// 支持一段时间--结束时间
    public var endTime = String()
    /// 支持一段时间--选择的结束时间
    public var chooseEndTimne = String()
    /// 支持--选择的开始时间和结束时间是否是同一天
    var isSomeDay = false
    var isFirst = false
    
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
    
    // MARK: - Public Method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.calendar)
        calendar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()

        }
       
        if self.isAllowSelectCrossTime {
            startTime = "2018/09/01"
            endTime = "2018/09/20"
            calendar.select(dateFormatter.date(from: startTime))
            calendar.select(dateFormatter.date(from: endTime))
            configureVisibleCells()
        }

    }
    
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

        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.weekdayTextColor = UIColor.blue
        calendar.appearance.borderRadius = 0
        // 日期是周末的
        calendar.appearance.titleWeekendColor = UIColor.red
        // 选择的颜色
        calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.todayColor = UIColor.white
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.firstWeekday = 1;
        calendar.calendarHeaderView.backgroundColor = UIColor.clear
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
        
        return calendar
    }()
    
    //MARK:-配置cell
    public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell:CalendarCell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! CalendarCell
        return cell
    }
    
    //MARK:-将要显示
    public func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
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
    //MARK:-设置子标题
    public func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        /// 允许多选
        if isAllowSelectCrossTime {
            
            if !self.startTime.isEmpty && !self.endTime.isEmpty && calendar.selectedDates.count==0{
                return nil
            }
            if !startTime.isEmpty &&  startTime != endTime && date.compare(self.dateFormatter.date(from: startTime)!)==ComparisonResult.orderedSame{
                return "开始"
            }
            
            if !endTime.isEmpty {
                
                if date.compare(self.dateFormatter.date(from: endTime)!)==ComparisonResult.orderedSame{
                    
                    if startTime == endTime {
                        return "开始/结束"
                    }else {
                        return "结束"
                    }
                    
                }
            }
            
        }else{
            
            return nil
            
        }
        
        return nil
    }
    
    //MARK:-选择某个日期
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        /// 允许多选
        if self.isAllowSelectCrossTime {
            if !endTime.isEmpty {
                calendar.deselect(dateFormatter.date(from: startTime)!)
                calendar.deselect(dateFormatter.date(from: endTime)!)
                endTime = ""
                startTime = dateFormatter.string(from: date)
                isSomeDay = true
            }else if startTime != ""{
                endTime = dateFormatter.string(from: date)
                if date.compare(self.dateFormatter.date(from: startTime)!)==ComparisonResult.orderedAscending {
                    calendar.deselect(dateFormatter.date(from: startTime)!)
                    endTime = ""
                    startTime = dateFormatter.string(from: date)
                    isSomeDay = true
                }
            }else {
                
                startTime = dateFormatter.string(from: date)
                isSomeDay = true
            }
            if !startTime.isEmpty && !endTime.isEmpty {
                
               //MARK:-DCG延时执行
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    if (self.selectCalendarBlock != nil) {
                        self.selectCalendarBlock?(self.startTime,self.self.endTime)
                    }
                }
                
            }
            self.calendar.reloadData()
            configureVisibleCells()
        } else {
            chooseTime = dateFormatter.string(from: date)
            self.calendar.reloadData()
            configureVisibleCells()
            
            if (selectCalendarBlock != nil) {
                selectCalendarBlock?(chooseTime,endTime)
            }
            
            
        }
        
    }
    
    //MARK:-反选某个日期
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        self.configureVisibleCells()
        /// 允许多选时间
        if isAllowSelectCrossTime {
            
            if isSomeDay{
                endTime = self.dateFormatter.string(from: date)
                calendar.select(date)
                self.calendar.reloadData()
                if (selectCalendarBlock != nil) {
                    selectCalendarBlock?(self.dateFormatter.string(from: date),self.dateFormatter.string(from: date))
                }
                
            }else{
                
                if isFirst{
                    
                    endTime = dateFormatter.string(from: date)
                    calendar.select(date)
                    calendar.reloadData()
                    if (selectCalendarBlock != nil) {
                        selectCalendarBlock?(startTime,endTime)
                    }
                    
                }else{
                    ///再次进入选择同一天
                    calendar.deselect(dateFormatter.date(from: startTime)!)
                    calendar.deselect(dateFormatter.date(from: endTime)!)
                    endTime = ""
                    startTime = dateFormatter.string(from: date)
                    calendar.select(date)
                    calendar.reloadData()
                    isFirst = true
                }
                
            }
        }else{
            calendar.select(date)
            calendar.reloadData()
            startTime = self.dateFormatter.string(from: date)
            
            if (selectCalendarBlock != nil) {
                selectCalendarBlock?(startTime,"")
            }
            
        }
        
    }
    
    //MARK:-绘制当前选择的日期
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    ///MARK:-配置cell
    public func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let customCell = (cell as? CalendarCell  )
        
        if position != .current {
            customCell?.middleLayer.isHidden = true
            customCell?.selectionLayer.isHidden = true
            return
        }
        if !endTime.isEmpty && !startTime.isEmpty{
            let isMiddle = date.compare(self.dateFormatter.date(from: startTime)!)==ComparisonResult.orderedDescending && date.compare(self.dateFormatter.date(from: endTime)!)==ComparisonResult.orderedAscending
            
            customCell?.middleLayer.isHidden = !isMiddle
            
        }else{
            
            customCell?.middleLayer.isHidden = true
        }
        
        let isStart = (self.dateFormatter.date(from: startTime) != nil) && self.gregorian.isDate(date, inSameDayAs: self.dateFormatter.date(from: startTime)!)
        
        let isEnd = (self.dateFormatter.date(from: endTime) != nil) && self.gregorian.isDate(date, inSameDayAs: self.dateFormatter.date(from: endTime)!)
        
        customCell?.selectionLayer.isHidden = !isEnd && !isStart
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
