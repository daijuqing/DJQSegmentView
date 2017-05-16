//
//  DJQContentView.swift
//  DJQSegment
//
//  Created by kezhiyou on 2017/5/10.
//  Copyright © 2017年 daijuqing. All rights reserved.
//

import UIKit

protocol DJQContentViewDelegate:class {
    
    func contentView( _ contentView:DJQContentView , targetIndex : NSInteger)
    func contentView( _ contentView:DJQContentView ,targetIndex : NSInteger, progress : CGFloat)
}



let kCollectionViewCell = "kCollectionViewCell"


class DJQContentView: UIView {

    weak var contentDelegate : DJQContentViewDelegate!
    
    
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    
    fileprivate var statOffset:CGFloat
    
    fileprivate lazy var collectionView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCell)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        return collectionView
        
    }()
    
    init(frame: CGRect , childVcs:[UIViewController] , parentVc:UIViewController) {

        

        
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.statOffset = 0.0
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DJQContentView{
    
    fileprivate func setupUI(){
        
        for childVc in childVcs{
            parentVc.addChildViewController(childVc)
        }
        addSubview(collectionView)
    }
}

extension DJQContentView : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCell, for: indexPath)

        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let child = childVcs[indexPath.item]
        child.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(child.view)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
    }
}



//MARK- UICollectionViewDelegate

extension DJQContentView:UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        contentEndScroll()
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            contentEndScroll()
            
        }
    }
    
    func contentEndScroll(){
        
        let currentIndex = collectionView.contentOffset.x / collectionView.bounds.width
        
        contentDelegate.contentView(self, targetIndex: NSInteger(currentIndex))
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        statOffset = CGFloat(scrollView.contentOffset.x)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard statOffset != CGFloat(scrollView.contentOffset.x) else {
            
            return
        }
        
        var targetIndex = 0
        var progress: CGFloat = 0.0
        let currentIndex = NSInteger(statOffset  / scrollView.bounds.width)

        
        
        
        

        if statOffset < scrollView.contentOffset.x {//左滑
            
            
            progress = (scrollView.contentOffset.x - statOffset)/scrollView.bounds.width
            
            
            targetIndex = currentIndex + 1

            if targetIndex > childVcs.count - 1 {
                
                targetIndex = childVcs.count - 1
            }
            
            
        }else{//右滑
            
            progress =  (statOffset - scrollView.contentOffset.x)/scrollView.bounds.width
            targetIndex = currentIndex - 1
            
            if targetIndex < 0 {
                
                targetIndex = 0
            }
        }
        
        
        print(progress)

        guard progress < 1 else {
            
            return
        }
        
        contentDelegate.contentView(self, targetIndex: targetIndex, progress: progress)
    }
    
}


//MARK - DJQTitlesViewDelegate

extension DJQContentView : DJQTitlesViewDelegate{
    
    
    func titleView(_ titlesView: DJQTitlesView, targetIndex: NSInteger) {
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
    }
    
    
}



