//
//  UIImage+yd.swift
//  YuDaoComponents
//
//  Created by mh on 2018/7/25.
//  Copyright © 2018年 Shanghai Blin Co.,Ltd. All rights reserved.
//

import Foundation

extension YuDaoExtesion where Base: UIImage {
    
    /// 缩放图片
    ///
    /// - Parameter scaleSize: 目标尺寸
    /// - Returns: 返回缩放后的图片
    public func scaled(by scaleSize: CGSize) -> UIImage? {
        
        guard scaleSize.width > 0 && scaleSize.height > 0 else {
            return nil
        }
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(scaleSize, false, 0.0)
        //绘制图片
        base.draw(in: CGRect(x: 0, y: 0, width: scaleSize.width, height: scaleSize.height))
        //从图形上下文获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭图形上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// 通过颜色生成图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 图片
    public static func image(by color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
}
