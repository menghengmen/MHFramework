//
//  ViewController.swift
//  YuDaoComponentsDemo
//
//  Created by WangXun on 2018/7/25.
//  Copyright © 2018年 Jiangsu Yu Dao Data Technology. All rights reserved.
//

import UIKit
import YuDaoComponents

class ViewController: UITableViewController {
    
    let dataSource = ["CountDownButton", "WebView","CalendarView","noDataView","buttonFlow","MVVM"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        switch dataSource[indexPath.row] {
        case "CountDownButton":
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountDownButtonVC") as! CountDownButtonVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "WebView":
            let vc = TestWebViewVC()
            let vm = TestWebViewVM()
            vm.urlStr.value = "http://119.3.38.104:8088/sample/privacyPolicy.html"
            vm.navTitle.value = "测试webView"
            vc.viewModel = vm
            vc.isEnableGoBackButton = true
            self.navigationController?.pushViewController(vc, animated: true)

        case "CalendarView":
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController

            
            self.navigationController?.pushViewController(vc, animated: true)
        case "noDataView":
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoDataViewController") as! NoDataViewController
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        
        case "buttonFlow":
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ButtonFlowVC") as! ButtonFlowVC
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "MVVM":
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MvvmDemoVC") as! MvvmDemoVC
            vc.viewModel = MvvmDemoVM()
            self.navigationController?.pushViewController(vc, animated: true)
        
        default:
            break
        }
        
    }
    
    


}

