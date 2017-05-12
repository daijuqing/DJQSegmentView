//
//  DJQSegmentView.swift
//  DJQSegment
//
//  Created by kezhiyou on 2017/5/10.
//  Copyright © 2017年 daijuqing. All rights reserved.
//

import UIKit

class DJQSegmentView: UIView {

    fileprivate var titles : [String]//标题数组
    fileprivate var childVcs : [UIViewController]//控制器数组
    fileprivate var parentVc : UIViewController//父控制器
    fileprivate var titleView : DJQTitlesView!
    fileprivate var style : DJQTitleStyle//状态

    init(frame: CGRect ,titles:[String],childVcs:[UIViewController],parentVc:UIViewController ,style:DJQTitleStyle) {
        
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK - 设置UI
extension DJQSegmentView{

    fileprivate func setupUI(){
        setupTitles()
        setupChileVcs()
        
    }
    private func setupTitles(){
        
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        
        titleView = DJQTitlesView(frame: titleFrame, titles: self.titles ,style:style)
        addSubview(titleView)
        
    }
    private func setupChileVcs(){
        let contentFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: bounds.height - titleView.frame.height)
        
        let contentView = DJQContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        
        titleView.titleViewDelegate = contentView
        contentView.contentDelegate = titleView
    }
    
}




