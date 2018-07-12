//
//  UIBarButtonItem-extension.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/6.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
/*
     class func makeItem(imageName:String,selectImageName:String,size:CGSize)-> UIBarButtonItem {
     
     let btn = UIButton()
     btn.setImage(UIImage(named: imageName), for: .normal)
     btn.setImage(UIImage(named: selectImageName), for: .highlighted)
     btn.frame = CGRect(origin: .zero, size: size)
     
     return  UIBarButtonItem(customView: btn)
     
     }
     */
    
    //便利构造函数 1>必须以convenience开头 2>在构造函数中必须明确调用一个设计的构造函数
    convenience init(imageName:String,selectImageName:String,size:CGSize) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: selectImageName), for: .highlighted)
        btn.frame = CGRect(origin: .zero, size: size)
//        btn.addTarget(target, action: #selector(getter:action), for: .touchUpInside)
        self.init(customView: btn)
    }
}
