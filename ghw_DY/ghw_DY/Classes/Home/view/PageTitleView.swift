//
//  PageTitleView.swift
//  ghw_DY
//
//  Created by guanqun.liu on 2018/7/6.
//  Copyright © 2018年 hengwei.gao. All rights reserved.
//

import UIKit

private let KTitleH:CGFloat = 40
private let KSliderH:CGFloat = 2

protocol PageTitleViewDelegate: class{
    func selectCurrentIndex(pageTieleView:PageTitleView, currentIndex:Int)
}

class PageTitleView: UIView {
    
    lazy var titleLabels :[UILabel] = [UILabel]()
    var titles  = [String]()
    var currentIndex:Int = 0
    weak var delegate:PageTitleViewDelegate?
    let slider = UIView()
    // MARK:-懒加载
    lazy var scrollView :UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.isUserInteractionEnabled = true
        scrollView.frame = bounds
        return scrollView
    }()
    
     init(frame: CGRect, titles:[String]) {
    
        super.init(frame: frame)
        self.titles = titles
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK:-设置UI界面
extension PageTitleView {
    
    func setupUI()  {
        addSubview(scrollView)
        //2添加title对应的label
        setupTitleLabels()
        //3添加底线 和滑块
        setupBottomLineAndScrollLine()
    }
    
    func setupTitleLabels()  {
        let labelW:CGFloat = KScreenW/CGFloat(titles.count)
        let labelH:CGFloat = KTitleH
        let labelY:CGFloat = 0
        for (index,title) in titles.enumerated() {
            
            let label = UILabel()
            label.textColor = UIColor.black
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            let labelX:CGFloat = CGFloat(index) * labelW
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            label.isUserInteractionEnabled = true
            let tagGes = UITapGestureRecognizer(target: self, action: #selector(self.titlelabelClick(TapGes:)))
            label.addGestureRecognizer(tagGes)
            scrollView.addSubview(label)
            titleLabels.append(label)
      
 
        }
 
    }
    func setupBottomLineAndScrollLine() {
        
        let bottomLineview = UIView()
        bottomLineview.frame = CGRect(x: 0, y: KNavigationBarH-0.5, width: KScreenW, height: 0.5)
        bottomLineview.backgroundColor = UIColor.lightGray
        scrollView.addSubview(bottomLineview)
        
        guard  let firstLabel = titleLabels.first else {return}
           firstLabel.textColor = UIColor.orange
        
        slider.backgroundColor = UIColor.orange
        slider.frame = CGRect(x: 0, y: KNavigationBarH - KSliderH, width: (firstLabel.bounds.width), height: KSliderH)
        scrollView.addSubview(slider)
        
 
    }
    
}

// MARK:-ACTion
extension PageTitleView {
    @objc func titlelabelClick(TapGes:UITapGestureRecognizer) {
        
        guard  let currentLabel = TapGes.view as? UILabel else {return}
       let oldLabel = titleLabels[currentIndex]
         oldLabel.textColor = UIColor.black
        currentLabel.textColor = UIColor.orange

        currentIndex = currentLabel.tag
        let sliderofsetX = CGFloat(currentIndex) * slider.frame.width
        
        UIView.animate(withDuration: 0.15) {
            self.slider.frame.origin.x = sliderofsetX
        }
        
        delegate?.selectCurrentIndex(pageTieleView: self, currentIndex: currentIndex)

        
    }
    
    
    func setscrollOfset(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        slider.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
    }
    
}
