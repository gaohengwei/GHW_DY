//
//  HomeViewController.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/6.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK:-懒加载
    lazy var pageTitleView :PageTitleView = {[weak self] in
       
        let titles = ["推荐","游戏","娱乐","趣玩"]
        
        let pageTitleView = PageTitleView(frame: CGRect(x:0, y:KNavigationBarH + KStatusBarH , width: KScreenW, height: KtabBarH), titles: titles)
        pageTitleView.delegate = self

        return pageTitleView
    }()
    

    lazy var pageContentView:PageContentView = {
        let contentH  = KscreenH - KNavigationBarH - KStatusBarH - KtabBarH - KtabBarH
        let contentFrame = CGRect(x: 0, y: KNavigationBarH + KStatusBarH + KtabBarH, width: KScreenW, height: contentH)
        
        var childVcs = [UIViewController]()
        
        childVcs.append(recommendVC())
        for _ in 0..<3 {
            let childVC = UIViewController()
            childVC.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(childVC)
 
        }
    
        let pageContentView = PageContentView(frame: contentFrame, childVCs: childVcs, parentVC: self)
        pageContentView.delegate = self
        return pageContentView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }
    



}

// MARK:-设置UI
extension HomeViewController {
    
 fileprivate func setupUI () {
    setupNavigationBar()
    // 添加pagetitleView
    view.addSubview(pageTitleView)
    view.addSubview(pageContentView)
    
    
    }
    func setupNavigationBar()  {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logo"), style: .plain, target: self, action: #selector(leftbarButtonClick))
        let size = CGSize(width: 40, height: 40)
        let histroyItem = UIBarButtonItem(imageName:"image_my_history", selectImageName: "image_my_history_click", size:size)
        navigationItem.rightBarButtonItems = [histroyItem]
        
    }
}
// MARK:-ACTION
extension HomeViewController:PageTitleViewDelegate,PageContentViewDelegate {
    @objc func leftbarButtonClick() {
        print("点击了左按钮")
    }
    @objc func hisroyitemClick() {
        print("点击了历史按钮")
    }
    
    // MARK:-pagedelegate
    func selectCurrentIndex(pageTieleView: PageTitleView, currentIndex: Int) {
        print(currentIndex)
        pageContentView.setCurrentIndex(index: currentIndex)
    }
    
    // MARK:-pageContentViewDelegate
    func setScrollofset(pageContentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setscrollOfset(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

