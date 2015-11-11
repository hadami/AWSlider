//
//  AWPageControl.swift
//  AWPageView
//
//  Created by chloe on 2015. 10. 14..
//  Copyright © 2015년 chloe. All rights reserved.
//

import UIKit

class AWPageControl: UIControl {

    @IBInspectable var numberOfPages : Int
    @IBInspectable var currentPage: Int
    
    @IBInspectable var pageIndicatorTintColor : UIColor = UIColor.clearColor()
    @IBInspectable var currentPageIndicatorTintColor : UIColor = UIColor.clearColor()
 
    var page : UIView?
    var current : UIView?
    
    required init?(coder aDecoder: NSCoder) {
        self.numberOfPages = 0
        self.currentPage = 0
        
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        self.numberOfPages = 0
        self.currentPage = 0
        
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (self.page == nil) {
            self.clipsToBounds = true
            
            var currentFrame = self.frame
            currentFrame.size.width = currentFrame.size.width/CGFloat(self.numberOfPages)
            currentFrame.origin.x = self.frame.size.width-currentFrame.size.width
            
            current = UIView(frame: CGRect(x: currentFrame.origin.x, y: 0, width: currentFrame.size.width, height: currentFrame.size.height))
            current!.backgroundColor = self.currentPageIndicatorTintColor
            
            page = UIView(frame: CGRect(x: currentFrame.size.width*CGFloat(self.currentPage+1)-self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            page!.backgroundColor = self.pageIndicatorTintColor
            
            self.addSubview(page!)
            page?.addSubview(current!)
        }
    }
    
    internal func updateCurrentPageDisplay() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            var pageFrame = self.page!.frame
            pageFrame.origin.x = (self.current?.frame.size.width)!*CGFloat(self.currentPage+1)-self.frame.size.width
            self.page?.frame = pageFrame
            
            }, completion: { (finished: Bool) in
                return true
        })
    }
    
//    func presentationCountForPageViewController
    
}
