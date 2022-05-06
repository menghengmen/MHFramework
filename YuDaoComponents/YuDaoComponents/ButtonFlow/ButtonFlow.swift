//
//  ButtonFlow.swift
//  YuDaoComponents
//
//  Created by mh on 2018/10/26.
//  Copyright © 2018 Shanghai Blin Co.,Ltd. All rights reserved.
//
//  按钮瀑布排列容器

import UIKit



/// 按钮瀑布排列容器
public class ButtonFlow: UIView {
    
    /// 布局信息
    public struct LayoutInfo {
        
        /// 文字边距
        public var font: UIFont = .systemFont(ofSize: 15)
        /// 文字边距
        public var textMargin: CGFloat = 5
        /// 元素的最小宽度
        public var itemMinWidth: CGFloat = 0
        /// 元素的最大宽度
        public var itemMaxWidth: CGFloat?
        /// 元素高度
        public var itemHeight: CGFloat = 32
        /// 水平间距
        public var itemSpace: CGFloat = 10
        /// 行间距
        public var lineSpace: CGFloat = 10
        /// 一行最大宽度
        public var lineMaxWidth: CGFloat = 320
        
        /// 默认布局
        static public var defaultLayout: LayoutInfo {
            return LayoutInfo()
        }
    }
    
    /// 按钮信息
    struct ButtonInfo {
        /// 位置
        var frame: CGRect
        /// 行
        var row: Int
        /// 列
        var column: Int
    }
    
   /// 类型
    public enum FlowViewType {
        ///  单选
        case singleSelectItem
        ///  多选
        case multiSelectItem
        /// 删除
        case deleteItem
        
    }
    
    // MARK: - 属性
    
    /// 所有元素
    public var allItems = [String]() {
        didSet {
            addButtons()
            invalidateIntrinsicContentSize()
        }
    }
    /// 当前选中元素
    public var selectedItems: Set<Int> {
        set {
            mSelectedItems = newValue
            reloadSelection()
        } get {
            return mSelectedItems
        }
    }
    
    /// 不可点击的元素
    public var disabledItems: Set<Int> = [] {
        didSet {
            reloadSelection()
        }
    }
    
    /// 保存当前选中元素
    private var mSelectedItems = Set<Int>()
 
    
    /// view的类型
    public var type: FlowViewType = .singleSelectItem {
        didSet {
            mSelectedItems.removeAll()
            reloadSelection()
        }
    }
    
   /// 单选情况下，是否可以取消选择（选中情况下点击）
    public var allowCancelSelect = false
    /// 删除的回调
    public var didDeleteItem: ((_ itemIndex: Int) -> Void)?
    
    /// 更新的回调
    public var didUpdateSelectedItems: ((_ items: Set<Int>) -> Void)?
    /// 定制按钮外观
    public var customButton: ((_ btn: UIButton, _ index: Int) -> Void)?

    /// 布局
    lazy public var layoutInfo: LayoutInfo = {
        var li = LayoutInfo.defaultLayout
        li.lineMaxWidth = self.frame.width
        return li
    }()
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: ButtonFlow.fullHeight(by: allItems, layoutInfo: layoutInfo))
    }
    
    
    // MARK: - 公有方法

    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutInfo.lineMaxWidth = self.frame.width
        relayoutButtons()
    }
    
    
    /// 计算完整高度
    ///
    /// - Parameters:
    ///   - items: 所有元素
    ///   - layoutInfo: 布局设置
    /// - Returns: 完整高度
    public static func fullHeight(by items: [String], layoutInfo: LayoutInfo = .defaultLayout) -> CGFloat {
        
        let newAry = resort(by: items, layoutInfo: layoutInfo)
        
        return newAry.last?.frame.maxY ?? 0
    }
    
    /// 计算完整行数
    ///
    /// - Parameters:
    ///   - items: 所有元素
    ///   - layoutInfo: 布局设置
    /// - Returns: 完整行数
    public static func fullLine(by items: [String], layoutInfo: LayoutInfo = .defaultLayout) -> Int {
        
        let newAry = resort(by: items, layoutInfo: layoutInfo)
        let lastButtonRow = newAry.last?.row
        return lastButtonRow != nil ? lastButtonRow! + 1 : 0
    }

    // MARK: - 私有方法
    
    /// 通过计算重新整理所有元素
    private static func resort(by items: [String], layoutInfo: LayoutInfo = .defaultLayout) -> [ButtonInfo] {
        
        var currentLineX: CGFloat = 0
        var currnetRow = 0
        var currnetColumn = 0
        
        var result = [ButtonInfo]()
        
        for anItem in items {
            
            let strWidth = anItem.yd.size(withFont: layoutInfo.font, limitWidth: CGFloat.greatestFiniteMagnitude).width
            var itemWidth = strWidth + layoutInfo.textMargin * 2
            
            if itemWidth < layoutInfo.itemMinWidth {
                itemWidth = layoutInfo.itemMinWidth
            }
            
            if let maxWidth = layoutInfo.itemMaxWidth {
                itemWidth = itemWidth > maxWidth ? maxWidth : itemWidth
            }
            
            if itemWidth > layoutInfo.lineMaxWidth {
                itemWidth = layoutInfo.lineMaxWidth
            }
            
            if currentLineX + itemWidth > layoutInfo.lineMaxWidth { // 换行
                currentLineX = 0
                currnetRow += 1
                currnetColumn = 0
            }
            
            result.append(ButtonInfo(frame: CGRect(
                x: currentLineX,
                y: (layoutInfo.itemHeight + layoutInfo.lineSpace) * CGFloat(currnetRow),
                width: itemWidth,
                height: layoutInfo.itemHeight), row: currnetRow, column: currnetColumn))
            
            currentLineX += itemWidth + layoutInfo.itemSpace
            currnetColumn += 1
        }
        
        return result
    }
    
    private func addButtons() {
        
        for aSubview in subviews {
            aSubview.removeFromSuperview()
        }
        
        mSelectedItems.removeAll()
        
        for (idx,anItem) in allItems.enumerated() {
            
            let btn = UIButton(type: UIButton.ButtonType.custom)
            addSubview(btn)
            
            btn.setTitle(anItem, for: .normal)
            btn.titleLabel?.font = layoutInfo.font
            btn.tag = 8000 + idx
            btn.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
            
            customButton?(btn, idx)
        }
        
    }
    
    /// 重新布局
    private func relayoutButtons() {
        
        let buttonInfos = ButtonFlow.resort(by: allItems, layoutInfo: layoutInfo)
        
        for (idx, aSubview) in subviews.enumerated() {
            
            if let btn = aSubview as? UIButton, let btnInfo = buttonInfos.yd.element(of: idx) {
                btn.frame = btnInfo.frame
            }
        }
    }
    
    /// 刷新按钮选择
    private func reloadSelection() {
        
        for aSubview in subviews {
            if let btn = aSubview as? UIButton {
                let idx = btn.tag - 8000
                btn.isEnabled = !disabledItems.contains(idx)
                btn.isSelected = mSelectedItems.contains(idx)
            }
        }
        
    }
    
    /// 点击按钮
    @objc private func clickButton(_ sender: UIButton) {
        
        let idx = sender.tag - 8000
       
        if disabledItems.contains(idx) {
            return
        }
        
        switch type {
        case .deleteItem:
            allItems.remove(at: idx)
            didDeleteItem?(idx)
        case .multiSelectItem:
             sender.isSelected.toggle()
             if sender.isSelected {
                mSelectedItems.insert(idx)
             } else {
                mSelectedItems.remove(idx)
            }
             didUpdateSelectedItems?(selectedItems)

        case .singleSelectItem:
         if  allowCancelSelect == false
             && sender.isSelected == true{
             return
           }
        
            sender.isSelected.toggle()
            mSelectedItems.removeAll()
            if sender.isSelected {
                mSelectedItems.insert(idx)
            } else {
                mSelectedItems.remove(idx)
            }
            reloadSelection()
            didUpdateSelectedItems?(selectedItems)
        default: break
           
        }
    }
    
    
}
