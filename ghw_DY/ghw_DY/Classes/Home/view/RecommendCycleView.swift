//
//  RecommendCycleView.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/11.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit
private let cycleCellID = "cycleCellID"
class RecommendCycleView: UIView {
    // MARK:自定义属性
    var cycleTimer:Timer?
    
    var cycleModels: [CycleModel]? {
        didSet {
            collectionView.reloadData()
            pageControl.numberOfPages = cycleModels?.count ?? 0
            let indexPath:IndexPath = IndexPath(row: ( cycleModels?.count ?? 0)*60, section: 0)
            collectionView.scrollToItem(at: indexPath , at: .left, animated: false)
            removeCycleTimer()
            addCycleTimer()
    
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    // MARK:-系统方法
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置该控件不跟随父控件拉伸而拉伸
        autoresizingMask = UIView.AutoresizingMask()
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: "CycleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cycleCellID)
    }
    
    override func layoutSubviews() {
        //在这个方法里能拿到真实的尺寸
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = self.bounds.size
 
    }


}

extension RecommendCycleView {
   class func RecommendCycleView() ->RecommendCycleView  {
      return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as!RecommendCycleView
    }
}
// MARK:-UICollectionViewDataSource
extension RecommendCycleView:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0)*1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cycleCellID, for: indexPath) as!CycleCollectionViewCell
        
        cell.cycleModel = cycleModels![indexPath.row % (cycleModels!.count)]

        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        addCycleTimer()
    }
    
    
}

// MARK:-定时器相关
extension RecommendCycleView {
   func addCycleTimer() {
    cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(changePage), userInfo: nil, repeats: true)
    RunLoop.main.add(cycleTimer!, forMode: RunLoop.Mode.common)
    }
    func removeCycleTimer()  {
        cycleTimer?.invalidate()//让定时器从循环中移除
        cycleTimer = nil
    }
    
    
    @objc func changePage()  {
       collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width, y: 0), animated: true)
    }
}
