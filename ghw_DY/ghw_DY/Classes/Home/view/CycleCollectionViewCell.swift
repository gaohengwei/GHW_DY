//
//  CycleCollectionViewCell.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/11.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit
import Kingfisher
class CycleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var cycleModel:CycleModel? {
        didSet {
            titleLabel.text = cycleModel?.title
            let iconURL = URL(string: cycleModel?.pic_url ?? "")
            imageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "Img_default"))
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
