//
//  MainViewController.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/6.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChirldVC(vcName: "Home")
        addChirldVC(vcName: "Live")
        addChirldVC(vcName: "follow")
       addChirldVC(vcName: "profile")
    }
    
    func addChirldVC(vcName:String)  {
        
        let vc = UIStoryboard(name: vcName, bundle: nil).instantiateInitialViewController()!
      addChild(vc)
    }


}
