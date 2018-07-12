//
//  recommendViewController.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/10.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit
private let kItemMargin:CGFloat = 10
let kNormalItemW = (KscreenH - 3 * kItemMargin) / 3.8
let kNormalItemH = kNormalItemW * 3 / 4
let kPrettyItemH = kNormalItemW * 5 / 4
private let KCycleViewH = KScreenW * 3 / 8
private let NormalCellID = "NormalCellID"
private let HeaderViewID = "HeaderViewID"
private let collectionHeaderID = "collectionHeaderID"
let PrettyCellID = "PrettyCellID"
class recommendVC: UIViewController {
    
    // MARK:懒加载
    fileprivate lazy var recommendVM:RecommendVM = RecommendVM()
    
    lazy var recommendCycleView:RecommendCycleView = {
       let recommendCycleView = RecommendCycleView.RecommendCycleView()
        
        recommendCycleView.frame = CGRect(x: 0, y: -KCycleViewH, width: KScreenW, height: KCycleViewH)
        return recommendCycleView
    }()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        layout.headerReferenceSize = CGSize(width: KScreenW, height: 50)
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.purple
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth ,.flexibleHeight] //这个属性是当self.view的framed发生变化时候.collectionview也跟着变化
      //注册cell
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: NormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: PrettyCellID)
          collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHeaderID)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       //设置UI界面
        setupUI()
        //请求数据
        loadData()
        collectionView.addSubview(recommendCycleView)
        collectionView.contentInset = UIEdgeInsets(top: KCycleViewH, left: 0, bottom: 0, right: 0)
    }
    


}

// MARK:-设置UI
extension recommendVC {
    
    func setupUI()  {
        view.addSubview(collectionView)
    }
}
// MARK:-collectionViewdataSource

extension recommendVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }else{
            return CGSize(width: kNormalItemW, height: kNormalItemH)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return recommendVM.anchorGroups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrettyCellID, for: indexPath) as! CollectionPrettyCell
            cell.anchor = recommendVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            return cell
        }else{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCellID, for: indexPath) as! CollectionNormalCell
              cell.anchor = recommendVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionHeaderID, for: indexPath)as! CollectionHeaderView
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        return headerView

    }
    
    
}

// MARK:-网络请求
extension recommendVC {
    func loadData()  {
     
        recommendVM.requestData {
            self.collectionView .reloadData()
        }
        //请求无限轮播图的数据
        recommendVM.requestCycleData {
            self.recommendCycleView.cycleModels = self.recommendVM.cycleModles
        }
        
        
    }
}
