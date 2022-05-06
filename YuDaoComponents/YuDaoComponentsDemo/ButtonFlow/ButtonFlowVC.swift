//
//  ButtonFlowVC.swift
//  YuDaoComponentsDemo
//
//  Created by WangXun on 2018/10/27.
//  Copyright © 2018 Jiangsu Yu Dao Data Technology Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit
import YuDaoComponents

class ButtonFlowVC: BaseViewController {
 
    let allItems = ["12","3456","23283","0000ssss","1123190389098321329490989279442", "asdoasjdoia", "asdqweqweqw", "1232", "2", "asoaxco 0sa", "1231023s", "aaa-oqwe0q", "adjaosdjiqw", "012odaos", "123j1oja","apioi"]
    
    
    @IBOutlet private weak var flowView: ButtonFlow!
    @IBOutlet private weak var multiSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowView.layoutInfo.itemMinWidth = 40
        
        flowView.customButton = { (btn) in
            btn.setTitleColor(UIColor.lightText, for: .normal)
            btn.setTitleColor(UIColor.darkText, for: .selected)
            
            btn.backgroundColor = .red
        }
       
        
        flowView.didUpdateSelectedItems = { (set) in
            mLog("选中：\(set)")
        }
        
        flowView.didUpdateAllItems = { (item) in
            mLog("剩余的：\(item)")

        }
        
    }
    
    @IBAction func clickRandom() {
        
        var number = arc4random() % 20 + 5
        var items = [String]()
        
        while number > 0 {
            items.append(allItems[Int(arc4random()) % allItems.count])
            number -= 1
        }
        
        flowView.allItems = items
        
    }
    @IBAction func changeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            flowView.type = .singleSelectItem
        } else if sender.selectedSegmentIndex == 1  {
            flowView.type = .multiSelectItem
        } else {
            flowView.type = .deleteItem
        }
    }
}
