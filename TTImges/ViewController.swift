//
//  ViewController.swift
//  TTImges
//
//  Created by le tong on 2019/12/9.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let TTFileImageView = UIImageView.init(frame: CGRect(x: 100, y: 0, width: 200, height: 300))
    let TTOriginImageView = UIImageView.init(frame: CGRect(x: 100, y: 350, width: 200, height: 100))
    let TTColorImageView = UIImageView.init(frame: CGRect(x: 100, y: 500, width: 200, height: 100))
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(TTFileImageView)
        self.view.addSubview(TTOriginImageView)
        self.view.addSubview(TTColorImageView)
        TTFileImageView.image = ttdrawImageFromFilePath(filePath: "/Users/letong/Desktop/TTPopView/TTImges/TTImges/TTImage.png")
        let corner: UIRectCorner = UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue)
        
        //        //颜色数组（这里使用三组颜色作为渐变）fc6820
        let compoents:[CGFloat] = [0xfc/255, 0x68/255, 0x20/255, 1,
                                   0xfe/255, 0xd3/255, 0x2f/255, 1,
                                   0xb1/255, 0xfc/255, 0x33/255, 1]
        TTOriginImageView.image = ttdrawOriginImage(corner: corner, radii: 20.0, color: UIColor.green)
        
        TTColorImageView.image = ttdrawBeautifulColorImage(corner: corner, radii: 20.0, compoents: compoents)
        
       
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (note) in
                                                // Unload large resources when off-screen
                                                self?.unloadImage()
        }
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (note) in
                                                // Unload large resources when off-screen
                                                self?.loadImage()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func unloadImage() -> Void {
        
    }
    func loadImage() -> Void {
       
    }
    
}

