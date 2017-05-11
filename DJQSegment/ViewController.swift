//
//  ViewController.swift
//  DJQSegment
//
//  Created by kezhiyou on 2017/5/10.
//  Copyright © 2017年 daijuqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        automaticallyAdjustsScrollViewInsets = false
        
        let titles = ["aaa","dfdfb","dfdfc","dfdfb","dfdfc","dfdfb","dfdfc","dfdfb","dfdfc","dfdfb","dfdfc"]

        
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count{
            let  vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        let segFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        let titleStyle = DJQTitleStyle()
        titleStyle.isScrollEnable = true
        let seg = DJQSegmentView(frame: segFrame, titles: titles, childVcs: childVcs, parentVc: self ,style:titleStyle)
        
        view.addSubview(seg)
        
    }


}

