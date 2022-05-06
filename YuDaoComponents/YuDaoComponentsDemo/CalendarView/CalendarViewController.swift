//
//  CalendarViewController.swift
//  YuDaoComponentsDemo
//
//  Created by 哈哈 on 2018/9/12.
//  Copyright © 2018年 Jiangsu Yu Dao Data Technology Co.,Ltd. All rights reserved.
//

import UIKit
import YuDaoComponents


class CalendarViewController: UIViewController {
   
    var dateFormatter :DateFormatter?
    var isBackTracking = false

    @IBOutlet var chooseDateBtn: UIButton!
    
    @IBOutlet var multipleBtn: UIButton!
    @IBOutlet var endDateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
       }
   
    
    fileprivate lazy var calendarPicker: CalenderViewPicker = {
        let startDateStr :String = "2017/09/01"
        let endDateStr :String = "2018/09/30"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let startDate = dateFormatter.date(from: startDateStr)
        let endDate  = dateFormatter.date(from: endDateStr)
        
        var calendarPicker = CalenderViewPicker.init(frame: CGRect(x: 0, y:self.view.frame.size.height, width:  self.view.frame.size.width, height: 0))
        calendarPicker.calenderView.dayNormalColor = UIColor.black
        calendarPicker.calenderView.weekColor = UIColor.red
        calendarPicker.calenderView.headerColor = UIColor.black
        calendarPicker.calenderView.headerWeekColor = UIColor.green
        calendarPicker.calenderView.minimumDate = startDate!
        calendarPicker.calenderView.maximumDate = endDate!
        calendarPicker.calenderView.isAllowSelectCrossTime = true
        calendarPicker.buttonColor = UIColor.green
        calendarPicker.selectCalendarBlock = {chooseDate,endDate in
            
            self.endDateBtn.setTitle("\(chooseDate)--\(endDate)", for: .normal)
           
        }
        return calendarPicker
        
    }()
    
    
    @IBAction func endDateClick(_ sender: Any) {

        self.view.addSubview(self.calendarPicker)
        self.calendarPicker.show()
    }
    
    @IBAction func chooseDate(_ sender: Any) {
      //  self.selectCalendar(allowMoreSection: false)
    }
    @IBAction func multipleDate(_ sender: Any) {
       // self.selectCalendar(allowMoreSection: true)
    }
   
    
//    func selectCalendar(allowMoreSection: Bool)  {
//        let startDateStr :String = "2016/09/01"
//        let endDateStr :String = "2018/09/30"
//        let dateFormatter = DateFormatter.init()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        let startDate = dateFormatter.date(from: startDateStr)
//        let endDate  = dateFormatter.date(from: endDateStr)
//
//        let calendar = CalendarController()
//        calendar.dayNormalColor = UIColor.black
//        calendar.weekColor = UIColor.red
//        calendar.headerColor = UIColor.black
//        calendar.headerWeekColor = UIColor.green
//        calendar.minimumDate = startDate!
//        calendar.maximumDate = endDate!
//        calendar.isAllowSelectCrossTime = allowMoreSection
//        calendar.selectCalendarBlock = { chooseDate,endDateStr in
//            if allowMoreSection == false {
//                self.chooseDateBtn.setTitle(chooseDate, for: .normal)
//            } else {
//                self.multipleBtn.setTitle("\(chooseDate)--\(endDateStr)", for: .normal)
//            }
//
//        }
//
//        self.navigationController?.pushViewController(calendar, animated: true)
//}

}
