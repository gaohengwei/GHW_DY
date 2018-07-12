//
//  PageContentView.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/9.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit
private let contentCollectionViewCellID = "contentCollectionViewCellID"

protocol PageContentViewDelegate {
    func setScrollofset(pageContentView:PageContentView,progress:CGFloat,sourceIndex:Int,targetIndex:Int)
}

class PageContentView: UIView {
    
   fileprivate var childVCs:[UIViewController]
  fileprivate weak var paretVC:UIViewController?
    var startOfsetX:CGFloat = 0
    var delegate:PageContentViewDelegate?
    var isClicktitle:Bool = false
    
    
    // MARK:-懒加载
    lazy var collectionView:UICollectionView = { [weak self] in
       
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = (self?.bounds.size)!
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCollectionViewCellID)
        collectionView.frame = bounds
        return collectionView
    }()
    
    init(frame: CGRect,childVCs:[UIViewController],parentVC:UIViewController) {
        
        self.childVCs = childVCs
        self.paretVC = parentVC
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
}

// MARK:-设置UI界面
extension PageContentView {
    
    func setupUI()  {
        for control in childVCs {
            paretVC?.addChild(control)
        }
        
        addSubview(collectionView)
        
        
    }
    
}

// MARK:-collectviewDatasourceAndDelegate
extension PageContentView :UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCollectionViewCellID, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVC = childVCs[indexPath.row]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOfsetX = scrollView.contentOffset.x
        isClicktitle = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isClicktitle {
            return
        }
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        //2 判断滑动方向
        let currentOffsetX = scrollView.contentOffset.x
         let scrollViewW = scrollView.bounds.width
        print(currentOffsetX)
        if currentOffsetX > startOfsetX {
            print("左滑")
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // 2.计算sourceIndex
            sourceIndex = Int( currentOffsetX / scrollViewW)
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            // 4.如果完全划过去
            if currentOffsetX - startOfsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else if (currentOffsetX < startOfsetX){
            print("右滑")
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
            
        }
        delegate?.setScrollofset(pageContentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
    
    
}

// MARK:-ACTION
extension PageContentView {
    func setCurrentIndex(index:Int)  {
        isClicktitle = true
        let offsetX = CGFloat(index) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        
        
    }
}
