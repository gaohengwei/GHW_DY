//
//  CycleModel.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/11.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit

@objc class CycleModel: NSObject {

    @objc var title : String = ""
    @objc var pic_url : String = ""
    @objc var anchor:AnchorModel?
    @objc var room:[String:Any]? {
        
        didSet {
            guard let room = room else {return}
            anchor = AnchorModel(dict: room)
        }
    }
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
