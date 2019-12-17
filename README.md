# TTImages-Swift

内存是有限且系统共享的资源，一个程序占用更多，系统和其他程序所能用的就更少。程序启动前都需要先加载到内存中，并且在程序运行过程中的数据操作也需要占用一定的内存资源。减少内存占用也能同时减少其对 CPU 时间维度上的消耗，从而使不仅你所开发的 App，其他 App 以及整个系统也都能表现的更好。而图片占用大量内存


1. 图片在内存使用上很容易产生较大的占用，如下图所示，一个图片文件从硬盘到展示需要经历加载-解码-渲染三步。以一个590KB大小、2048 * 1536 像素的图片为例，在3x设备上解码后的内存占用能够达到10MB(2048 * 3 * 1536 * 3 * 4 Bytes/pixel)之多

2. UIImage 会首先把图片解码加载到内存，内部空间坐标转换也会带来巨大损耗
3. ImageIO 能够在不产生 dirty memory 的情况下读取到图片尺寸和元信息，其内存损耗等于缩减后的图片尺寸产生的内存占用
4. 最后Kyle给出了一点建议就是优化 App 的后台相关行为，即在 App 进入后台时释放内存占用较大的资源，进入前台时重新加载


### 绘制纯色图片

```
let renderer = UIGraphicsImageRenderer(size: bounds.size)
        
        let image = renderer.image { (context) in
            color.setFill()
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
            path.addClip()
            UIRectFill(bounds)
        }
        return image
```

### 绘制渐变色图片

```
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
        
```

### 从文件中取图片

```
 let url = NSURL(fileURLWithPath: filePath)
        
        let imageSource = CGImageSourceCreateWithURL(url, nil)
        let options: [NSString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: 1000,
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ]
        let scaleImage = CGImageSourceCreateThumbnailAtIndex(imageSource!, 0, options as CFDictionary)
        
        let imageIO = UIImage.init(cgImage: scaleImage!)
        return imageIO
        
```