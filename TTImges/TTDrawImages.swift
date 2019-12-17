//
//  TTDrawImages.swift
//  TTImges
//
//  Created by le tong on 2019/12/9.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import ImageIO

class TTDrawImages: NSObject {
    
}
// 绘制渐变色图片
func ttdrawBeautifulColorImage(corner: UIRectCorner,radii: CGFloat, compoents: [CGFloat]) -> UIImage{
    let bounds = CGRect(x: 0, y: 0, width: 200, height: 100)
    if #available(iOS 10, *){
        let renderer = UIGraphicsImageRenderer(size: bounds.size)

        let image = renderer.image { (context) in
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
            path.addClip()
            UIRectFill(bounds)
            //使用rgb颜色空间
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            //没组颜色所在位置（范围0~1)
            let locations:[CGFloat] = [0,0.5,1]
            //生成渐变色（count参数表示渐变个数）
            let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                      locations: locations, count: locations.count)!

            //渐变开始位置
            let start = CGPoint(x: bounds.minX, y: bounds.minY)
            //渐变结束位置
            let end = CGPoint(x: bounds.maxX, y: bounds.minY)
            //绘制渐变
            context.cgContext.drawLinearGradient(gradient, start: start, end: end,
                                                 options: .drawsBeforeStartLocation)
        }
        return image
    }else{
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
    
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corner,
                                cornerRadii: CGSize(width: radii, height: radii))
        path.addClip()
        UIRectFill(bounds)
    
        let context: CGContext = UIGraphicsGetCurrentContext()!;
        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //没组颜色所在位置（范围0~1)
        let locations:[CGFloat] = [0,0.5,1]
        //生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                  locations: locations, count: locations.count)!
        
        //渐变开始位置
        let start = CGPoint(x: bounds.minX, y: bounds.minY)
        //渐变结束位置
        let end = CGPoint(x: bounds.maxX, y: bounds.minY)
        //绘制渐变
        context.drawLinearGradient(gradient, start: start, end: end,
                                             options: .drawsBeforeStartLocation)
         let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// 绘制纯色图片
func ttdrawOriginImage(corner: UIRectCorner,radii:CGFloat,color:UIColor) -> UIImage{
    let bounds = CGRect(x: 0, y: 0, width: 200, height: 100)
    if #available(iOS 10, *){
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        
        let image = renderer.image { (context) in
            color.setFill()
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
            path.addClip()
            UIRectFill(bounds)
        }
        return image
    }else{
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        color.setFill()
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corner,
                                cornerRadii: CGSize(width: radii, height: radii))
        path.addClip()
        UIRectFill(bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// 从文件夹中取出图片
func ttdrawImageFromFilePath(filePath: String) -> UIImage {
    if #available(iOS 10, *){
        let url = NSURL(fileURLWithPath: filePath)
        
        let imageSource = CGImageSourceCreateWithURL(url, nil)
        let options: [NSString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: 1000,
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ]
        let scaleImage = CGImageSourceCreateThumbnailAtIndex(imageSource!, 0, options as CFDictionary)
        
        let imageIO = UIImage.init(cgImage: scaleImage!)
        return imageIO
    }else{
        let image = UIImage(contentsOfFile: filePath)
        let scale: CGFloat = 0.2
        
        let imageW = (image?.size.width)! * scale
        let imageH = (image?.size.height)! * scale
        let size = CGSize(width: imageW, height: imageH)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let resizedImage = renderer.image { (context) in
            image?.draw(in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
        }
        return resizedImage
    }
    
}
