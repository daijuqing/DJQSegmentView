//
//  DJQTitlesView.swift
//  DJQSegment
//
//  Created by kezhiyou on 2017/5/10.
//  Copyright © 2017年 daijuqing. All rights reserved.
//

import UIKit

protocol DJQTitlesViewDelegate:class{
    
    func titleView(_ titlesView :DJQTitlesView ,targetIndex :NSInteger)
    
}

class DJQTitlesView: UIView {

  

    weak var titleViewDelegate:DJQTitlesViewDelegate!
    
    fileprivate var currentIndex : NSInteger//当前选择的标题
    
    fileprivate var titles:[String]
    fileprivate var style:DJQTitleStyle
    
    //标题label数组
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    
    fileprivate lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    
    
    init(frame: CGRect , titles:[String] ,style:DJQTitleStyle) {
        self.titles = titles
        self.style = style
        self.currentIndex = 0//默认第0个
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
extension DJQTitlesView{
    
    fileprivate func setupUI(){
        addSubview(scrollView)
        
        setupTitleLabels()
        setupTitleFrame()
    }
    
    fileprivate func setupTitleLabels()
    {
        
        for (i , title) in titles.enumerated()
        {
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: CGFloat(style.forntSize))
            titleLabel.tag = i
            titleLabel.textColor = i == 0 ? style.seletedColor:style.normalColor
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            
            
            //添加手势
            let tapGes = UITapGestureRecognizer(target: self, action:#selector(titleViewClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
        }
        
    }
    
    fileprivate func setupTitleFrame()
    {
        let count = titleLabels.count
        
        
        for (i,label) in titleLabels.enumerated(){
            
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            var x : CGFloat = 0
            let y : CGFloat = 0

            if style.isScrollEnable
            {//可以滚动
              
                //根据字数设置宽度
                w = (label.text! as NSString).boundingRect(with:  CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : label.font], context: nil).width

                
                if i == 0
                {
                    x = style.iteamMargin * 0.5
                    
                }else
                {
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.iteamMargin * 0.5
                }
                
            
            }else
            {//不能滚动
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
   
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
        }
        
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.iteamMargin * 0.5 , height: 0) : CGSize.zero
    }
}

// MARK - 事件监听

extension DJQTitlesView{
    
    @objc fileprivate func titleViewClick(_ ges : UITapGestureRecognizer){
        
        let targetLabel = ges.view as! UILabel

        
        adjustTitlelabel(targetIndex: targetLabel.tag)
       
        
        titleViewDelegate.titleView(self, targetIndex: currentIndex)

       }

    func adjustTitlelabel(targetIndex : NSInteger){
        
        
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        
//        if (sourceLabel.tag != targetIndex) {
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.seletedColor
//        }
        
        
        
        
        
        if style.isScrollEnable {
            
            var offsetX = targetLabel.center.x - scrollView.frame.width * 0.5
            
            //左侧
            if offsetX < 0 {
                
                offsetX = 0.0
                
            }
            
            //右侧
            if offsetX  > scrollView.contentSize.width - scrollView.bounds.width {
                
                offsetX =  targetLabel.center.x - offsetX - style.iteamMargin * 0.5
                
            }
            scrollView.setContentOffset(CGPoint( x : offsetX, y :0), animated: true)
            
        }
        
            currentIndex = targetIndex

    }
}



// MARK - DJQContentViewDelegate

extension DJQTitlesView:DJQContentViewDelegate{
    
    func contentView(_ contentView: DJQContentView, targetIndex: NSInteger) {
        
        adjustTitlelabel(targetIndex: targetIndex)
    }
    
    func contentView(_ contentView: DJQContentView, targetIndex: NSInteger, progress: CGFloat) { 
        
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let deltaRGB = UIColor.getRGBdelta(firstRGBColor: style.seletedColor, secondRGBColor: style.normalColor)
        let sourceRGB = UIColor.getRGB(style.normalColor)
        let currentRGB = UIColor.getRGB(style.seletedColor)
        
        targetLabel.textColor = UIColor(r: sourceRGB().0 + deltaRGB.0 * progress , g: sourceRGB().1 + deltaRGB.1 * progress, b: sourceRGB().2 + deltaRGB.2 * progress)

        sourceLabel.textColor = UIColor(r: currentRGB().0 - deltaRGB.0 * progress, g: currentRGB().1 - deltaRGB.1 * progress, b: currentRGB().2 - deltaRGB.2 * progress)
    }
}



