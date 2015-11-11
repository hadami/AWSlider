//
//  ViewController.swift
//  AWPageView
//
//  Created by chloe on 2015. 10. 14..
//  Copyright © 2015년 chloe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pageControl: AWPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe Left")
            
            if (self.pageControl.numberOfPages > self.pageControl.currentPage+1) {
                self.pageControl.currentPage++
            }
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
            
            if (self.pageControl.currentPage != 0) {
                self.pageControl.currentPage--
            }
        }
        
        self.pageControl.updateCurrentPageDisplay()
    }
}

